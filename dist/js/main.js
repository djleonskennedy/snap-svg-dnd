(function() {
  var _compaire, _state, _utils, firstHandler01, firstHandler02, handler, lock, move, paper, pinkStyle, secondHandler01, secondHandler02, start, stop, updateState;

  _utils = {
    events: {
      events: {},
      on: function(eventName, fn) {
        this.events[eventName] = this.events[eventName] || [];
        return this.events[eventName].push(fn);
      },
      off: function(eventName, fn) {
        var i, results;
        if (this.events[eventName]) {
          i = 0;
          results = [];
          while (i < this.events[eventName].length) {
            if (this.events[eventName][i] === fn) {
              this.events[eventName].splice(i, 1);
              break;
            }
            results.push(i++);
          }
          return results;
        }
      },
      emit: function(eventName, data) {
        if (this.events[eventName]) {
          return this.events[eventName].forEach(function(fn) {
            return fn(data);
          });
        }
      }
    },
    _range: function(val, min, max) {
      return val >= min && val <= max;
    }
  };

  paper = Snap('#svg');

  pinkStyle = {
    fill: "#f0f"
  };

  lock = true;

  _compaire = function(el, e, fn) {
    var compaired;
    compaired = 0;
    if (_utils._range(e.layerX, el.cx, el.cx + el.w)) {
      ++compaired;
    }
    if (_utils._range(e.layerY, el.cy, el.cy + el.h)) {
      ++compaired;
    }
    if (compaired === 2) {
      return fn(true);
    } else {
      return fn(false);
    }
  };

  move = function(dx, dy, x, y) {
    var clientX, clientY;
    clientX = null;
    clientY = null;
    if (typeof dx === 'object' && dx.type === 'touchmove') {
      clientX = dx.changedTouches[0].clientX;
      clientY = dx.changedTouches[0].clientY;
      dx = clientX - this.data('ox');
      dy = clientY - this.data('oy');
    }
    return this.attr({
      transform: this.data('origTransform') + (this.data('origTransform') ? 'T' : 't') + [dx, dy]
    });
  };

  start = function(x, y, ev) {
    if (typeof x === 'object' && x.type === 'touchstart') {
      x.preventDefault();
      this.data('ox', x.changedTouches[0].clientX);
      this.data('oy', x.changedTouches[0].clientY);
    }
    return this.data('origTransform', this.transform().local);
  };

  stop = function(e) {
    var _handlers;
    _handlers = [firstHandler01, firstHandler02, secondHandler01, secondHandler02];
    return _handlers.forEach(function(_handler, i, arr) {
      return _compaire(_handler.getBBox(), e, (function(_this) {
        return function(compaired) {
          return handler(_this.data('requires'), _handler.data('requires'), compaired);
        };
      })(this));
    }, this);
  };

  _state = {
    firstHandler: 0,
    secondHandler: 0
  };

  handler = function(required, actual, compaired) {
    if (compaired) {
      if (required === actual) {
        if (_state[actual.slice(0, -2)] < 2) {
          _state[actual.slice(0, -2)] += 1;
        }
      }
    } else {
      if (_state[actual.slice(0, -2)] > 0) {
        _state[actual.slice(0, -2)] -= 1;
      }
    }
    return updateState();
  };

  updateState = function(state) {
    return console.log(_state);
  };

  firstHandler01 = paper.circle(20, 80, 20).attr(pinkStyle).data('requires', 'firstHandler01');

  firstHandler02 = paper.circle(100, 80, 20).attr(pinkStyle).data('requires', 'firstHandler02');

  secondHandler01 = paper.rect(150, 80, 40, 40).attr(pinkStyle).data('requires', 'secondHandler01');

  secondHandler02 = paper.rect(200, 80, 40, 40).attr(pinkStyle).data('requires', 'secondHandler02');

  paper.circle(20, 20, 20).data('requires', 'firstHandler01').drag(move, start, stop);

  paper.circle(40, 20, 20).data('requires', 'firstHandler02').drag(move, start, stop);

  paper.rect(60, 20, 40, 40).data('requires', 'secondHandler01').drag(move, start, stop);

  paper.rect(90, 20, 40, 40).data('requires', 'secondHandler02').drag(move, start, stop);

}).call(this);
