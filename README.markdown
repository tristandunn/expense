# Expense

Simple, personal expense tracking.

## Install

1. Clone the repository.
2. Change to the repository directory.
3. Update the submodules.
   <pre>
   git submodule init
   git submodule update
   </pre>
4. Copy the database.example.yml to database.yml and update if needed.
5. Create and migrate the database.
   <pre>
   rake db:create
   rake db:migrate
   </pre>