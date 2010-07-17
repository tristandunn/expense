# Expense

Simple, personal expense tracking.

## Install

1. Clone the repository.
2. Copy the database.example.yml to database.yml and update if needed.
   <pre>
   cp config/database.example.yml config/database.yml
   </pre>
3. Ensure you have the required gems installed.
   <pre>
   bundle install
   </pre>
4. Create and migrate the database.
   <pre>
   rake db:create db:migrate
   </pre>

*Note:* You may need an older version of `sqlite3-ruby` on OS X Leopard.

## iPhone

A simple iPhone-specific interface exists for expense entry and viewing.

![iPhone interface.](http://cloud.github.com/downloads/tristandunn/expense/expense.iphone.png)

## License

The MIT License

Copyright (c) 2010 Tristan Dunn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
