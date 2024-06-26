import mysql.connector
from datetime import datetime, timedelta;

# Database connection
class Database:
    def __init__(self):
        self.conn = mysql.connector.connect(
            host="localhost",
            user="your_username",
            password="your_password",
            database="LibraryDB"
        )
        self.cursor = self.conn.cursor()

    def execute_query(self, query, params=None):
        self.cursor.execute(query, params or ())
        self.conn.commit()

    def fetch_all(self, query, params=None):
        self.cursor.execute(query, params or ())
        return self.cursor.fetchall()

    def close(self):
        self.cursor.close()
        self.conn.close()

# Book class
class Book:
    def __init__(self, title, author, isbn):
        self.title = title
        self.author = author
        self.isbn = isbn
        self.status = 'Available'

    def check_out(self, db, patron_id):
        db.execute_query(
            "UPDATE Books SET Status = 'Checked Out' WHERE ISBN = %s AND Status = 'Available'",
            (self.isbn,)
        )
        due_date = datetime.now() + timedelta(days=14)
        db.execute_query(
            "INSERT INTO CheckedOutBooks (BookID, PatronID, CheckoutDate, DueDate) VALUES ((SELECT BookID FROM Books WHERE ISBN = %s), %s, CURDATE(), %s)",
            (self.isbn, patron_id, due_date.strftime('%Y-%m-%d'))
        )

    def return_book(self, db):
        db.execute_query(
            "UPDATE Books SET Status = 'Available' WHERE ISBN = %s",
            (self.isbn,)
        )
        db.execute_query(
            "DELETE FROM CheckedOutBooks WHERE BookID = (SELECT BookID FROM Books WHERE ISBN = %s)",
            (self.isbn,)
        )

# Patron class
class Patron:
    def __init__(self, name, library_card_number):
        self.name = name
        self.library_card_number = library_card_number

    def check_out_book(self, db, book_isbn):
        book = Book(None, None, book_isbn)
        book.check_out(db, self.library_card_number)

    def return_book(self, db, book_isbn):
        book = Book(None, None, book_isbn)
        book.return_book(db)

    def list_checked_out_books(self, db):
        result = db.fetch_all(
            "SELECT b.Title, b.Author, c.CheckoutDate, c.DueDate FROM CheckedOutBooks c JOIN Books b ON c.BookID = b.BookID WHERE c.PatronID = %s",
            (self.library_card_number,)
        )
        for row in result:
            print(f"Title: {row[0]}, Author: {row[1]}, Checkout Date: {row[2]}, Due Date: {row[3]}")

# Library class
class Library:
    def __init__(self):
        self.db = Database()

    def add_book(self, title, author, isbn):
        self.db.execute_query(
            "INSERT INTO Books (Title, Author, ISBN) VALUES (%s, %s, %s)",
            (title, author, isbn)
        )

    def remove_book(self, isbn):
        self.db.execute_query(
            "DELETE FROM Books WHERE ISBN = %s",
            (isbn,)
        )

    def register_patron(self, name, library_card_number):
        self.db.execute_query(
            "INSERT INTO Patrons (Name, LibraryCardNumber) VALUES (%s, %s)",
            (name, library_card_number)
        )

    def unregister_patron(self, library_card_number):
        self.db.execute_query(
            "DELETE FROM Patrons WHERE LibraryCardNumber = %s",
            (library_card_number,)
        )

    def lend_book(self, isbn, library_card_number):
        patron = Patron(None, library_card_number)
        patron.check_out_book(self.db, isbn)

    def receive_returned_book(self, isbn):
        book = Book(None, None, isbn)
        book.return_book(self.db)

    def search_books_by_title(self, title):
        result = self.db.fetch_all(
            "SELECT * FROM Books WHERE Title LIKE %s",
            ('%' + title + '%',)
        )
        for row in result:
            print(f"BookID: {row[0]}, Title: {row[1]}, Author: {row[2]}, ISBN: {row[3]}, Status: {row[4]}")

    def search_books_by_author(self, author):
        result = self.db.fetch_all(
            "SELECT * FROM Books WHERE Author LIKE %s",
            ('%' + author + '%',)
        )
        for row in result:
            print(f"BookID: {row[0]}, Title: {row[1]}, Author: {row[2]}, ISBN: {row[3]}, Status: {row[4]}")

    def __del__(self):
        self.db.close()

# Example usage
if __name__ == "__main__":
    library = Library()