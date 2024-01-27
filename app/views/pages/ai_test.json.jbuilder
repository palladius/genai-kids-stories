# https://dev.to/ayushmann/how-to-use-json-jbuilder-in-rails-49ef
json.name 'Riccardo'
json.surname 'Carlesso'
json.email 'ti.piacerebbe@gmail.com'
# json.address do
#     json.street '1234 1st Ave'
# #     city 'New York'
# #     state 'NY'
# #     zip 10065
# # end
json.preferences do
  json.fav_wine "Amarone di Valpolicella and Applauz"
  json.fav_language 'Ruby'
  json.fav_blog 'https://ricc.rocks/'
end

json.further_readings "https://htmx.org/extensions/client-side-templates/ ,       Anche questo sembra una figata: https://marcus-obst.de/blog/htmx-json-handling "


# Array:
# json.array! @posts do |post|
#   json.id post.id
#   json.title post.title
#   json.body post.body
# end
