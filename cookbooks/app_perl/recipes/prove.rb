# run tests
node["app"]["perl"]["psgi_apps"].each do |app|

  bash 'run_tests' do

    environment   app['env']

    cwd           app['target_path']

    code          "prove -I lib/"

  end

end
