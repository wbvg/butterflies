require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'active_support/all'
require 'json'

before do
  q = "SELECT DISTINCT family FROM butterflies"
  @families = run_sql(q)
end

get '/' do
  redirect to( '/butterflies' )
end

get '/new' do
  erb :new
end


post '/create' do
  q = "INSERT INTO butterflies(name, photo, family) VALUES ( '#{params['name']}' , '#{params['photo']}', '#{params['family']}' )"
# binding.pry
  run_sql(q)
  redirect to( '/butterflies' )
end

post '/butterflies/:id' do
# binding.pry
q = "UPDATE butterflies SET name='#{params['name']}' ,photo='#{params['photo']}' , family='#{params['family']}'
WHERE id=#{params[:id]}"
run_sql(q)
redirect to('/butterflies')
end



post '/butterflies/:id/delete' do
q = "DELETE FROM butterflies WHERE id=#{params[:id]}"
run_sql(q)
redirect to('/butterflies')
#binding.pry
end

get '/butterflies/:id/edit' do
q = " SELECT * FROM butterflies WHERE id=#{params[:id]} "
edit_rows = run_sql(q)
@butterfly = edit_rows.first

erb :new
end


get '/butterflies' do
  q = "SELECT * FROM butterflies"
  @butterflies = run_sql(q)
  erb :butterflies
end

get '/butterflies/:family' do
  q = "SELECT * FROM butterflies WHERE family='#{params[:family]}' "
  @butterflies = run_sql(q)

  erb :butterflies
end


def run_sql(query)
  conn = PG.connect(:dbname => 'butterfly_db', :host => 'localhost')
  result = conn.exec(query)
  conn.close

  result
end


