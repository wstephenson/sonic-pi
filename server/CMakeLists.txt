set(SERVER_FILES
  bin/clear-logs.rb
  bin/init-script.rb
  bin/sonic-pi-server.rb
  bin/test.rb
  bin/doc.rb
  bin/launch-gce
  bin/task-clear.rb
  bin/web-server.rb
  bin/exit-script.rb
  bin/port-discovery.rb
  bin/task-register.rb
  )

INSTALL(PROGRAMS ${SERVER_FILES} DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/bin)
INSTALL(DIRECTORY lib DESTINATION ${CMAKE_INSTALL_DATAROOTDIR})
