#pragma once
#include <list>
#include <functional>
#include <map>
#include <utility>


//Inspired by https://juanchopanzacpp.wordpress.com/2013/02/24/simple-observer-pattern-implementation-c11/
template <typename Event> class Caller{
public:
	template<typename Listener>
	void subscribeListener(const Event& eve, Listener&& listener){
		_listenerLogger[eve].push_back(std::forward<Listener>(listener));
	}
	template<typename Listener>
	void unsubscribeListener(const Event& eve, Listener&& listener){
		_listenerLogger[eve].remove(std::forward<Listener>(listener));
	}
protected:
	void notify(const Event& eve) const{
		//for(const auto& listener: _listenerLogger.at(eve))
		if(_listenerLogger.find(eve) != _listenerLogger.end()){
		 for(std::list<std::function<void()>>::const_iterator listener =_listenerLogger.at(eve).begin(); listener!=_listenerLogger.at(eve).end(); listener++){
		  (*listener)();
		 }
		}
	}

private:
	std::map <Event, std::list<std::function<void()>>> _listenerLogger;
};


/* How to use?
foo(int blah){
go_crazy();
}
enum Event {Hi, Bye, Die};
Caller<Event> c;
c.subscribeListener(Die, std::bind(foo, gaah));
or
c.subscribeListener(Die, std::bind(ClassB::foo, this, gaah));

c.notify(Die); // Calls foo(gaah)
*/
