const { Sequelize } = require("sequelize");

const sequelize = new Sequelize("book-store", "root", "", {
  host: "localhost",
  dialect: "mysql",
  pool: {
    max: 10,
    min: 0,
    acquire: 30000,
    idle: 10000,
  },
});

const connectWithRetry = async () => {
  let connected = false;
  const maxRetries = 5; // Maximum number of retry attempts
  let attempts = 0;

  while (!connected && attempts < maxRetries) {
    try {
      await sequelize.authenticate();
      console.log("Database connection established successfully.");
      connected = true; // Exit the loop on successful connection
    } catch (error) {
      attempts++;
      console.error(
        `Unable to connect to the database (Attempt ${attempts}/${maxRetries}):`,
        error
      );
      await new Promise((resolve) => setTimeout(resolve, 5000)); // Wait 5 seconds before retrying
    }
  }

  if (!connected) {
    console.error("Max retries reached. Exiting the application.");
    process.exit(1); // Exit the application if unable to connect
  }
};

// Start connection attempt
connectWithRetry();

module.exports = sequelize;
