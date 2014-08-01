node[:deploy].each do |application, deploy|
  uwsgi_service "myapp" do
    home_path "/var/www/app"
    pid_path "/var/run/uwsgi-app.pid"
    host "127.0.0.1"
    port 8080
    worker_processes 2
    app "flask:app"
  end

end
