const { User } = require("../models");
const responseHandler = require("../utils/responseHandler");
const Utils = require("../utils/hashFunctions");
const createUploader = require("../utils/uploadHandler");
const path = require("path");
const fs = require("fs");
const upload = createUploader();

exports.createUser = async (req, res) => {
  try {
    req.query.uploadType = "profile";

    upload.array("profile", 1)(req, res, async (err) => {
      if (err) {
        console.error("Multer error:", err);
        if (err.code === "LIMIT_UNEXPECTED_FILE") {
          return responseHandler(
            res,
            400,
            "Too many files uploaded. Maximum 10 files are allowed."
          );
        }
        return responseHandler(res, 400, "File upload failed", err.message);
      }
      if (!req.files || req.files.length === 0) {
        return responseHandler(res, 400, "No files uploaded");
      }
      try {
        const {
          username,
          password,
          fullName,
          email,
          address,
          phoneNumber,
          birth,
        } = req.body;
        let profilePicture = `/profiles/${req.files[0].filename}`; // Assuming the first uploaded file is the profile picture

        const hashedPassword = await Utils.hashPassword(password);
        const user = await User.create({
          username,
          password: hashedPassword,
          fullName,
          email,
          address,
          phoneNumber,
          birth,
          profilePicture,
        });

        return responseHandler(res, 201, "User created successfully", user);
      } catch (e) {
        return responseHandler(res, 500, "Error processing content", e);
      }
    });
  } catch (error) {
    return responseHandler(res, 500, "Error creating user", error);
  }
};

exports.getUserProfile = async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await User.findByPk(userId);
    if (!user) {
      return responseHandler(res, 404, "User not found");
    }
    return responseHandler(res, 200, "User profile retrieved successfully!", user);
  } catch (error) {
    return responseHandler(res, 500, "Error fetching user profile", error);
  }
};

exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;
    const user = await User.findOne({ where: { username } });
    if (!user) {
      return responseHandler(res, 404, "User not found");
    }
    const isPasswordValid = await Utils.comparePassword(
      password,
      user.password
    );
    if (!isPasswordValid) {
      return responseHandler(res, 401, "Invalid password");
    }
    return responseHandler(res, 200, "Login successful", user);
  } catch (error) {
    return responseHandler(res, 500, "Error logging in", error);
  }
};

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll();
    return responseHandler(
      res,
      200,
      "All users retrieved successfully!",
      users
    );
  } catch (error) {
    return responseHandler(res, 400, "Failed to retrieve users!");
  }
};

exports.editUser = async (req, res) => {
  try {
    req.query.uploadType = "profile";

    upload.array("profile", 1)(req, res, async (err) => {
      if (err) {
        console.error("Multer error:", err);
        if (err.code === "LIMIT_UNEXPECTED_FILE") {
          return responseHandler(
            res,
            400,
            "Too many files uploaded. Maximum 1 file is allowed."
          );
        }
        return responseHandler(res, 400, "File upload failed", err.message);
      }

      try {
        const userId = req.params.id;
        const user = await User.findByPk(userId);

        if (!user) {
          return responseHandler(res, 404, "User not found");
        }

        // Get update fields from request body
        const {
          username,
          password,
          fullName,
          email,
          address,
          phoneNumber,
          birth,
        } = req.body;

        // Prepare update object
        const updateData = {
          username: username || user.username,
          fullName: fullName || user.fullName,
          email: email || user.email,
          address: address || user.address,
          phoneNumber: phoneNumber || user.phoneNumber,
          birth: birth || user.birth,
        };

        // Handle password update if provided
        if (password) {
          updateData.password = await Utils.hashPassword(password);
        }

        // Handle profile picture update if new file is uploaded
        if (req.files && req.files.length > 0) {
          // Delete old profile picture if it exists
          if (user.profilePicture) {
            const oldProfilePath = path.join(
              __dirname,
              "../dist/profile",
              user.profilePicture.replace("profile/", "")
            );
            if (fs.existsSync(oldProfilePath)) {
              fs.unlinkSync(oldProfilePath);
            }
          }

          updateData.profilePicture = `profile/${req.files[0].filename}`;
        }

        // Update user
        await user.update(updateData);

        // Fetch the updated user
        const updatedUser = await User.findByPk(userId);

        return responseHandler(
          res,
          200,
          "User updated successfully",
          updatedUser
        );
      } catch (e) {
        // If there's an error and a new file was uploaded, clean it up
        if (req.files && req.files.length > 0) {
          const filePath = path.join(
            __dirname,
            "../dist/profile",
            req.files[0].filename
          );
          if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath);
          }
        }
        return responseHandler(res, 500, "Error processing content", e);
      }
    });
  } catch (error) {
    return responseHandler(res, 500, "Error updating user", error);
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await User.findByPk(userId);

    if (!user) {
      return responseHandler(res, 404, "User not found");
    }

    // Delete profile picture if it exists
    if (user.profilePicture) {
      const profilePath = path.join(
        __dirname,
        "../dist/profile",
        user.profilePicture.replace("profile/", "")
      );
      if (fs.existsSync(profilePath)) {
        fs.unlinkSync(profilePath);
      }
    }

    // Delete the user
    await user.destroy();

    return responseHandler(res, 200, "User deleted successfully");
  } catch (error) {
    return responseHandler(res, 500, "Error deleting user", error);
  }
};
