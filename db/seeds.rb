# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

t1 = Topic.create(name: 'jquery')
t2 = Topic.create(name: 'javascript')
e = Expert.create(name: 'John Resig', twitter: 'jeresig', linkedin: 'jeresig')

t1.experts << e

e.tweets.create(text: 'A call for more on-demand Opera films by', rate: 5, date: Date.current, link:'')

