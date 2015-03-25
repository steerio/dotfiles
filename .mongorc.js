//// Useful helpers

exists = { $exists: true }
missing = { $exists: false }
reallyNull = { $type: 10 }
notNull = { $not: reallyNull }

function int(n) { return NumberInt(n) }

function sum(k,v) {
  return Array.sum(v)
}

//// Collection

DBCollection.prototype.get = function (id) {
  return this.findOne({ _id: id });
}

DBCollection.prototype.mget = function (ids) {
  return this.find({ _id: { $in: ids }});
}

DBCollection.prototype.mapReduceInline = function () {
  var args = Array.prototype.slice.call(arguments);
  if (args.length < 3) args.push({});
  args[2].out = { inline: 1 };
  return this.mapReduce.apply(this, args);
}

DBCollection.prototype.mapReduceObj = function () {
  var obj = {};
  this.mapReduceInline.apply(this, arguments).results.forEach(function (i) {
    obj[i._id] = i.value;
  });
  return obj;
}

// Delegated methods (see definitions below)

DBCollection.prototype.last = function () {
  return this.find().last();
}

DBCollection.prototype.lastAt = function () {
  return this.find().lastAt();
}

DBCollection.prototype.map = function (fn) {
  return this.find().map(fn);
}

//// Query

DBQuery.prototype.rewind = function () {
  delete this._cursor;
  delete this._cursorSeen;
  this._numReturned = 0;
  return this;
}

DBQuery.prototype.one = function () {
  return this.limit(1)[0];
}

DBQuery.prototype.latest = function () {
  return this.sort({createdAt: -1});
}

DBQuery.prototype.last = function () {
  return this.latest().one();
}

DBQuery.prototype.lastAt = function () {
  return this.last().createdAt;
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
