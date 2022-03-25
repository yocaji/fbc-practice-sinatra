# My Memo (Sinatra)

## Getting Started

1. Clone this repository:  
  `git clone https://github.com/yocajii/fbc-practice-sinatra.git`
2. Install gems:  
  `bundle install`
3. Create database:  
   `psql`  
   `create database mymemo;`  
   `\q`
4. Create table:  
   `psql -d mymemo`
   ```
   CREATE TABLE notes (
     id SERIAL,
     title VARCHAR(80) NOT NULL,
     text VARCHAR(1600) NOT NULL,
     PRIMARY KEY (id)
   );
   ```
5. Run:  
  `bundle exec ruby app.rb`
6. Visit the top page:  
   `http://localhost:4567/notes`
