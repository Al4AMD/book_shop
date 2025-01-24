const express = require("express");
const bookController = require("../controllers/bookController");

const bookRouter = express.Router();

bookRouter.post("/createBook", bookController.createBook);

bookRouter.get("/getAllBooks", bookController.getAllBooks);

bookRouter.get("/getAllGenres", bookController.getAllGenres);

bookRouter.get("/getBook/:id", bookController.getBookById);

bookRouter.get("/getUserBooks/:userId", bookController.getUserBook);

bookRouter.get("/getAllBooks/:genre", bookController.getBooksByGenre);

bookRouter.patch("/editBook/:id", bookController.editBook);

bookRouter.delete("/deleteBook/:id", bookController.deleteBook);

module.exports = bookRouter;
