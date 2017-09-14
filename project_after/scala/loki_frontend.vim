MaqueAddService 'guard', { 'size': 20, 'start': 1, 'name': 'guard',
      \ 'position': 0.9 }
call CreateSbtCommand('start jetty container', 'jetty:start', 0)

ProAdd! loki_core
ProAdd! restrecord
