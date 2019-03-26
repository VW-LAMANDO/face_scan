typedef void EventCallback(Object arg);

class EventBus{

    Map _map = Map<String,List<EventCallback>>();

    EventBus._instance();

    static EventBus _singleton = EventBus._instance();

    factory EventBus() => _singleton;

    void on(String args, EventCallback f){

      if(args == null || f == null) return;
      _map[args] ??= List<EventCallback>();
      _map[args].add(f);
    }

    void off(String args, [EventCallback f]){
      List list = _map[args];
      if(args == null || list == null){
        return;
      }

      if(f == null){

        _map[args] = null;
      }else{
        list.remove(f);
      }
    }

    void trigger(String args,[Object para]){
      var list = _map[args];
      if(args == null || list == null){
        return;
      }
      list.forEach((item)=>item(para));
    }

}