//// Useful helpers

exists = { $exists: true }
missing = { $exists: false }
reallyNull = { $type: 10 }
notNull = { $not: reallyNull }
multi = { multi: true }

function int(n) { return NumberInt(n) }

function beginsWith(w) {
  return {$regex: "^"+w};
}

function emit(attr, n) {
  return eval("(function () { emit(this."+attr+", "+(n || 1)+")})")
}

function emitKeys() {
  for (var k in this) emit(k, 1);
}

function sum(k,v) {
  return Array.sum(v)
}

function min(k,v) {
  var res=v[0], len=v.length;
  for (var i=1; i<len; i++)
    if (v[i] < res) res = v[i];
  return res;
}

function max(k,v) {
  var res=v[0], len=v.length;
  for (var i=1; i<len; i++)
    if (v[i] > res) res = v[i];
  return res;
}

Number.prototype.toDate = function () {
  return new Date(this*1000);
}
Number.prototype.millisToDate = function () {
  return new Date(this);
}

ISODate.prototype.ymd = function() {
  return this.toISOString().substr(0,10);
}

//// Collection

DBCollection.prototype.get = function (id) {
  return this.findOne({ _id: id });
}

DBCollection.prototype.oid = function (id) {
  return this.findOne({ _id: ObjectId(id) });
}

DBCollection.prototype.email = function (email) {
  return this.findOne({ email: email });
}

DBCollection.prototype.user = function (u, q) {
  return this.find(Object.merge(q, { user: u._id }));
}

DBCollection.prototype.mget = function (ids) {
  return this.find({ _id: { $in: ids }});
}

DBCollection.prototype.mri = function () {
  var args = Array.prototype.slice.call(arguments), keep;
  var opts = { out: { inline: 1 }};
  if (args.length < 3) {
    args.push(opts);
  } else {
    args[2] = opts = Object.merge(args[2], opts, false);
    keep = opts.keep; delete opts.keep;
  }
  var res = this.mapReduce.apply(this, args);
  if (keep) {
    res.results = res.results.filter(i => keep(i.value));
    res.counts.kept = res.results.length;
  }
  return res;
}

DBCollection.prototype.mr = function () {
  var obj = {};
  this.mri.apply(this, arguments).results.forEach(function (i) {
    obj[i._id] = i.value;
  });
  return obj;
}

DBCollection.prototype.frequencies = function (k) {
  return this.mr(emit(k), sum);
}

DBCollection.prototype.upObj = function (obj) {
  arguments[0] = { _id: obj._id };
  return this.update.apply(this, arguments);
}

DBCollection.prototype.upById = function (id) {
  arguments[0] = { _id: id };
  return this.update.apply(this, arguments);
}

DBCollection.prototype.upByObjectId = function (id) {
  arguments[0] = { _id: ObjectId(id) };
  return this.update.apply(this, arguments);
}

DBCollection.prototype.setObj = function (obj, sets) {
  arguments[0] = { _id: obj._id };
  arguments[1] = { $set: sets };
  return this.update.apply(this, arguments);
}

DBCollection.prototype.setById = function (id, sets) {
  arguments[0] = { _id: id };
  arguments[1] = { $set: sets };
  return this.update.apply(this, arguments);
}

DBCollection.prototype.sumBy = function (by) {
  return this.mr(
    typeof(by) == 'function' ? by : emit(by),
    sum);
}

// Delegated methods (see definitions below)

DBCollection.prototype.ids = function () {
  return this.find().ids();
}

DBCollection.prototype.last = function (k) {
  return this.find().last(k);
}

DBCollection.prototype.lastAt = function (k) {
  return this.find().lastAt(k);
}

DBCollection.prototype.map = function (fn) {
  return this.find().map(fn);
}

//// Query

DBQuery.prototype.ids = function () {
  return this.map("_id")
}

DBQuery.prototype.rewind = function () {
  delete this._cursor;
  delete this._cursorSeen;
  this._numReturned = 0;
  return this;
}

DBQuery.prototype.one = function () {
  return this.limit(1)[0];
}

DBQuery.prototype.latest = function (k) {
  var q = {};
  q[k || "created"] = -1;
  return this.sort(q);
}

DBQuery.prototype.last = function (k) {
  return this.latest(k).one();
}

DBQuery.prototype.lastAt = function (k) {
  if (!k) k = "created";
  return this.last(k)[k];
}

// Sometimes you need to reduce locally

DBQuery.prototype.reduce = function (fn, acc) {
  // Not testing the value (as it could be null or even undefined),
  // testing if anything was given.
  if (arguments.length < 2)
    if (this.hasNext())
      acc = this.next();
    else
      return null;
  while (this.hasNext()) acc = fn(acc, this.next());
  return acc;
}

// Map/filter aware next method (hello, sequences)

DBQuery.prototype.next = function () {
  this._exec();
  var redo, ret;
  do {
    redo = false;
    var o = this._cursor.hasNext();
    if (o)
      this._cursorSeen++;
    else
      throw "error hasNext: "+o;

    ret = this._cursor.next();
    if (ret.$err) throw "error: "+tojson(ret);
    this._numReturned++;

    if (this._pipe) {
      try {
        for (var i=0; i < this._pipe.length; i++) ret = this._pipe[i](ret);
      } catch (err) {
        if (err == this.filter)
          redo = true;
        else
          throw err;
      }
    }
  } while (redo);

  return ret;
}

// Mapping, filtering, also a map() that accepts strings

var juxt;

(function () {
  function prop(arg) {
    return typeof(arg) == "string" ?
      eval("(function (obj) { return obj."+arg+" })") :
      arg;
  }

  juxt = function () {
    var fns = Array.prototype.map.call(arguments, prop);
    return function (obj) {
      return fns.map(function (fn) {
        return fn(obj);
      });
    }
  }

  var orig = Array.prototype.map;
  Array.prototype.map = function (fn) {
    return orig.call(this, prop(fn));
  }

  DBQuery.prototype.map = function (fn) {
    if (!this._pipe) this._pipe = [];
    this._pipe.push(prop(fn));
    return this;
  }

  var filter = DBQuery.prototype.filter = function (fn) {
    if (!this._pipe) this._pipe = [];
    fn = prop(fn);
    this._pipe.push(function (i) {
      if (!fn(i)) throw filter;
      return i;
    });
    return this;
  }
})();

function wrapInts(obj) {
  switch (typeof(obj)) {
    case "number":
      return Math.floor(obj) == obj ? NumberInt(obj) : obj;
      break;
    case "object":
      var out = new obj.__proto__.constructor();
      for (var k in obj) out[k] = wrapInts(obj[k]);
      return out;
      break;
    default:
      return obj;
  }
}
