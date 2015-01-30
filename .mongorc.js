(function () {
  function prop(path) {
    return eval("(function (obj) { return obj."+path+" })");
  }

  var orig = Array.prototype.map;
  Array.prototype.map = function (fn) {
    if (typeof(fn) == "string") ;
    return orig.call(this, typeof(fn) == "string" ? prop(fn) : fn);
  }

  DBQuery.prototype.map = function (fn) {
    if (typeof(fn) == "string") fn = prop(fn);
    var a = [];
    while (this.hasNext()) a.push(fn(this.next()));
    return a;
  }
})();

DBCollection.prototype.get = function (id) {
  return this.findOne({ _id: id });
}

DBQuery.prototype.one = function () {
  return this.limit(1)[0];
}

DBQuery.prototype.last = function () {
  return this.sort({createdAt: -1}).one();
}

DBQuery.prototype.lastAt = function () {
  return this.last().createdAt;
}
