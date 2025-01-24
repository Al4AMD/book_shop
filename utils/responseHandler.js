const responseHandler = (res, statusCode, message, data = null) => {
  res.status(statusCode).json({
    result: statusCode === 200 || statusCode === 201 ? "success" : "failed",
    statusCode,
    message,
    data,
  });
};

module.exports = responseHandler;
