# Clear existing data in correct order to respect foreign key constraints
puts "Cleaning database..."

# Destroy in correct order to avoid foreign key violations
Ticket.destroy_all
UserProject.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."

# Create Manager first
manager = User.create!(
  name: 'John Manager',
  email: 'manager@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'manager'
)

puts "Manager created: #{manager.email}"

# Create Developers
developers = []
3.times do |i|
  developers << User.create!(
    name: "Developer #{i + 1}",
    email: "developer#{i + 1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    role: 'developer'
  )
  puts "Developer #{i + 1} created: #{developers.last.email}"
end

# Create QAs
qas = []
2.times do |i|
  qas << User.create!(
    name: "QA #{i + 1}",
    email: "qa#{i + 1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    role: 'qa'
  )
  puts "QA #{i + 1} created: #{qas.last.email}"
end

puts "Creating projects..."

# Create Projects
project1 = Project.create!(
  name: 'E-commerce Website',
  desc: 'Build a new e-commerce platform',
  manager: manager
)

project2 = Project.create!(
  name: 'Mobile App',
  desc: 'Develop a cross-platform mobile application',
  manager: manager
)

puts "Projects created: #{project1.name}, #{project2.name}"

# Assign users to projects
puts "Assigning users to projects..."

project1.user_projects.create!(user: developers[0])
project1.user_projects.create!(user: developers[1])
project1.user_projects.create!(user: qas[0])

project2.user_projects.create!(user: developers[1])
project2.user_projects.create!(user: developers[2])
project2.user_projects.create!(user: qas[1])

puts "Creating tickets..."

# Create sample tickets
Bug.create!(
  title: 'Login page broken',
  description: 'Users cannot login with correct credentials',
  status: 'new_ticket',
  project: project1,
  qa: qas[0],
  deadline: Date.today + 7.days
)

Feature.create!(
  title: 'Add dark mode',
  description: 'Implement dark mode theme option',
  status: 'new_ticket', 
  project: project1,
  qa: qas[0],
  deadline: Date.today + 14.days
)

Bug.create!(
  title: 'Mobile app crashes on startup',
  description: 'App crashes immediately after launching on iOS',
  status: 'started',
  project: project2,
  qa: qas[1],
  developer: developers[1],
  deadline: Date.today + 5.days
)

puts "Seed data created successfully!"
puts "=" * 50
puts "Login credentials:"
puts "Manager: #{manager.email} / password"
puts "Developers: #{developers.map(&:email).join(', ')} / password"
puts "QAs: #{qas.map(&:email).join(', ')} / password"
puts "=" * 50