"use strict";

var low = require('lowdb');
var connections;

function objectify(array){
    return array.reduce(function(p,c){
        p[c[0]] = c[1];
        return p;
    }, {});
}

function getDB(connDate){
    return connections[connDate];
}

exports.connectToImpl = function(filename){
    return function(optsArray){
        return function (){
            var connectionName = new Date().toISOString();
            if (optsArray.length == 1) {
                connections = objectify([[ connectionName, low(filename, optsArray[0])]]);
            } else {
                connections = objectify([[ connectionName, low(filename)]]);
            }
            return connectionName;
        }
    }
}

exports.getImpl = function (connDate) {
    return function (query) {
        return function() {
            var db = getDB(connDate);
            var result = db.get(query).value();
            if (result) {
                return result;
            } else {
                return [];
            }
        }
    }
}

exports.defaultsImpl = function (connDate) {
    return function (names) {
        return function() {
            var db = getDB(connDate);
            names.forEach(function (name) {
                db.defaults(objectify([[name, []]])).value();
            });
        }
    }
}

exports.pushImpl = function (connDate) {
    return function (query) {
        return function (o) {
            return function() {
                var db = getDB(connDate);
                db.get(query).push(o).value();
            }
        }
    }
}

exports.removeImpl = function (connDate) {
    return function (query) {
        return function (o) {
            return function() {
                var db = getDB(connDate);
                db.get(query).remove(o).value();
            }
        }
    }
}
