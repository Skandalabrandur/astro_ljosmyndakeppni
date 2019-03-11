# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#Superuser
User.create(
    email: 'admin', 
    password_digest: BCrypt::Password.create("LEdC9beyJQ2C6PBZ"),
    judge: true,
    admin: true,
)

User.create(
    email: 'judge',
    password_digest: BCrypt::Password.create("mike"),
    judge: true,
    admin: false
)

User.create(
    email: 'judge2',
    password_digest: BCrypt::Password.create("dredd"),
    judge: true,
    admin: false
)

User.create(
    email: 'judge3',
    password_digest: BCrypt::Password.create("fudge"),
    judge: true,
    admin: false
)

User.create(
    email: 'steini',
    password_digest: BCrypt::Password.create("1234"),
    judge: false,
    admin: false
)
