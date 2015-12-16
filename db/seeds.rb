# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

t1 = Topic.create(name: 'jQuery')
t2 = Topic.create(name: 'javascript')
e = Expert.create(name: 'John Resig', rate: 10)
p = Profile.create(url: 'https://twitter.com/jeresig',
                   profile_image_url:"http://pbs.twimg.com/profile_images/628273703587975168/YorO7ort_normal.png",
                   location:"Brooklyn, NY", 
                   description:"Creator of @jquery, JavaScript programmer, author, Japanese woodblock nerd (http://t.co/vc69XXB4fq), work at @khanacademy.",
                   profile_type: "twitter", screen_name: "jeresig")

t1.experts << e
t2.experts << e

e.profiles << p

#u = User.create(name: 'f5App', email: 'emgomezcarmona@gmail.com', password: 'dexterlab', password_confirmation: 'dexterlab')

