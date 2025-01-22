const { Book } = require("../models");
const responseHandler = require("../utils/responseHandler");
const createImageUploader = require("../utils/uploadHandler");
const path = require("path");
const fs = require("fs");

const upload = createImageUploader();

// Create a new book
exports.createBook = async (req, res) => {
  try {
    req.query.uploadType = "cover";

    upload.array("cover", 1)(req, res, async (err) => {
      if (err) {
        console.error("Upload error:", err);
        return responseHandler(res, 400, err.message);
      }

      if (!req.files || req.files.length === 0) {
        return responseHandler(res, 400, "No cover image uploaded");
      }

      try {
        const {
          serialNumber,
          title,
          author,
          genre,
          publicationYear,
          publisher,
          price,
        } = req.body;

        const cover = `cover/${req.files[0].filename}`;

        const book = await Book.create({
          serialNumber,
          title,
          cover,
          author,
          genre,
          publicationYear,
          publisher,
          price,
        });

        return responseHandler(res, 201, "Book created successfully", book);
      } catch (e) {
        // Clean up the uploaded file
        if (req.files && req.files.length > 0) {
          const filePath = path.join(
            __dirname,
            "../dist/cover",
            req.files[0].filename
          );
          if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
          }
        }

        if (e.name === "SequelizeUniqueConstraintError") {
          return responseHandler(
            res,
            400,
            "A book with this serial number already exists"
          );
        }

        return responseHandler(res, 500, "Error creating book", e.message);
      }
    });
  } catch (error) {
    return responseHandler(res, 500, "Error creating book", error.message);
  }
};

// Get all books
exports.getAllBooks = async (req, res) => {
  try {
    const books = await Book.findAll({
      attributes: [
        "id",
        "serialNumber",
        "title",
        "cover",
        "author",
        "genre",
        "publicationYear",
        "publisher",
        "price",
        "createdAt",
        "updatedAt",
      ],
    });
    return responseHandler(res, 200, "Books retrieved successfully", books);
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving books", error);
  }
};

exports.getBookById = async (req, res) => {
  try {
    const { id } = req.params;
    const book = await Book.findByPk(id, {
      attributes: [
        "id",
        "serialNumber",
        "title",
        "cover",
        "author",
        "genre",
        "publicationYear",
        "publisher",
        "price",
        "createdAt",
        "updatedAt",
      ],
    });

    if (!book) {
      return responseHandler(res, 404, "Book not found");
    }

    return responseHandler(res, 200, "Book retrieved successfully", book);
  } catch (error) {
    return responseHandler(res, 400, "Failed to get book", error);
  }
};

// Get books by genre
exports.getBooksByGenre = async (req, res) => {
  try {
    const { genre } = req.params;
    const books = await Book.findAll({
      where: {
        genre: genre,
      },
      attributes: [
        "id",
        "serialNumber",
        "title",
        "cover",
        "author",
        "genre",
        "publicationYear",
        "publisher",
        "price",
        "createdAt",
        "updatedAt",
      ],
    });

    if (books.length === 0) {
      return responseHandler(res, 404, "No books found for this genre");
    }

    return responseHandler(res, 200, "Books retrieved successfully", books);
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving books", error);
  }
};

// Get all genres
exports.getAllGenres = async (req, res) => {
  try {
    const genres = await Book.findAll({
      attributes: ["genre"],
      group: ["genre"],
    });
    const genreList = genres.map((item) => item.genre);
    return responseHandler(res, 200, "Genres retrieved successfully", genreList);
  } catch (error) {
    return responseHandler(res, 500, "Error retrieving genres", error);
  }
};

// Edit a book
exports.editBook = async (req, res) => {
  try {
    req.query.uploadType = "cover";

    upload.array("cover", 1)(req, res, async (err) => {
      if (err) {
        console.error("Upload error:", err);
        return responseHandler(res, 400, err.message);
      }

      try {
        const bookId = req.params.id;
        const book = await Book.findByPk(bookId, {
          attributes: [
            "id",
            "serialNumber",
            "title",
            "cover",
            "author",
            "genre",
            "publicationYear",
            "publisher",
            "price",
            "createdAt",
            "updatedAt",
          ],
        });

        if (!book) {
          return responseHandler(res, 404, "Book not found");
        }

        const {
          serialNumber,
          title,
          author,
          genre,
          publicationYear,
          publisher,
          price,
        } = req.body;

        const updateData = {
          serialNumber: serialNumber || book.serialNumber,
          title: title || book.title,
          author: author || book.author,
          genre: genre || book.genre,
          publicationYear: publicationYear || book.publicationYear,
          publisher: publisher || book.publisher,
          price: price || book.price,
        };

        // Handle cover update if new file is uploaded
        if (req.files && req.files.length > 0) {
          // Delete old cover if it exists
          if (book.cover) {
            const oldCoverPath = path.join(__dirname, "../dist", book.cover);
            if (fs.existsSync(oldCoverPath)) {
              fs.unlinkSync(oldCoverPath);
            }
          }

          updateData.cover = `cover/${req.files[0].filename}`;
        }

        await book.update(updateData);

        // Fetch updated book with specific attributes
        const updatedBook = await Book.findByPk(bookId, {
          attributes: [
            "id",
            "serialNumber",
            "title",
            "cover",
            "author",
            "genre",
            "publicationYear",
            "publisher",
            "price",
            "createdAt",
            "updatedAt",
          ],
        });

        return responseHandler(
          res,
          200,
          "Book updated successfully",
          updatedBook
        );
      } catch (e) {
        // Clean up uploaded file if there's an error
        if (req.files && req.files.length > 0) {
          const filePath = path.join(
            __dirname,
            "../dist/cover",
            req.files[0].filename
          );
          if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
          }
        }

        if (e.name === "SequelizeUniqueConstraintError") {
          return responseHandler(
            res,
            400,
            "A book with this serial number already exists"
          );
        }

        return responseHandler(res, 500, "Error processing content", e.message);
      }
    });
  } catch (error) {
    return responseHandler(res, 500, "Error updating book", error.message);
  }
};

// Delete a book
exports.deleteBook = async (req, res) => {
  try {
    const bookId = req.params.id;
    const book = await Book.findByPk(bookId, {
      attributes: [
        "id",
        "serialNumber",
        "title",
        "cover",
        "author",
        "genre",
        "publicationYear",
        "publisher",
        "price",
        "createdAt",
        "updatedAt",
      ],
    });

    if (!book) {
      return responseHandler(res, 404, "Book not found");
    }

    // Delete cover file if it exists
    if (book.cover) {
      const coverPath = path.join(__dirname, "../dist", book.cover);
      if (fs.existsSync(coverPath)) {
        fs.unlinkSync(coverPath);
      }
    }

    await book.destroy();
    return responseHandler(res, 200, "Book deleted successfully");
  } catch (error) {
    return responseHandler(res, 500, "Error deleting book", error);
  }
};
