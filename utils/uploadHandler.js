const multer = require("multer");
const path = require("path");

const createImageUploader = () => {
  const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      // Use the query string or a custom header if req.body is unavailable
      const uploadType = req.query.uploadType || req.headers["uploadtype"];

      if (file.mimetype.startsWith("image/")) {
        if (uploadType === "cover") {
          cb(null, "dist/cover");
        } else if (uploadType === "profile") {
          cb(null, "dist/profile");
        } else {
          cb(new Error("Invalid upload type specified"), null);
        }
      } else {
        cb(new Error("Invalid file type. Only images are allowed."), null);
      }
    },
    filename: function (req, file, cb) {
      const ext = path.extname(file.originalname);
      cb(null, file.originalname);
    },
  });

  return multer({
    storage: storage,
    fileFilter: (req, file, cb) => {
      const allowedMimeTypes = [
        "image/jpeg",
        "image/png",
        "image/jpg",
        "image/webp",
      ];
      if (allowedMimeTypes.includes(file.mimetype)) {
        cb(null, true);
      } else {
        cb(
          new Error(
            `Invalid file type. Allowed types: ${allowedMimeTypes.join(", ")}`
          ),
          false
        );
      }
    },
  });
};

module.exports = createImageUploader;
