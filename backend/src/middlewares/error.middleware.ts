import { ErrorResponse } from "../utils/response.utils";

export const errorHandler = ({ code, error }: { code: any; error: any }) => {
  if (code === "INTERNAL_SERVER_ERROR") {
    return Response.json(
      {
        message: "Internal Server Error",
        error: error.message,
        success: false,
      },
      { status: 500, statusText: "Internal Server Error" },
    );
  }
  if (code === "NOT_FOUND") {
    return Response.json(
      { message: "Not Found", error: error.message, success: false },
      { status: 404, statusText: "Not Found" },
    );
  }
  if (code === "VALIDATION") {
    const errors: any = {};
    error.all.forEach((err: any) => {
      const path = err.path.replace("/", "");
      if (path) {
        errors[path] = err.summary;
      }
    });

    return Response.json(
      {
        message: error.all[0].message,
        error: errors,
        success: false,
      },
      { status: 400, statusText: "Validation Error" },
    );
  }
  if (code === "PARSE") {
    return Response.json(
      { message: "Parse Error", error: error.message, success: false },
      { status: 400, statusText: "Parse Error" },
    );
  }
  if (code === "INVALID_COOKIE_SIGNATURE") {
    return Response.json(
      {
        message: "Invalid Cookie Signature",
        error: error.message,
        success: false,
      },
      { status: 400, statusText: "Invalid Cookie Signature" },
    );
  }
  if (code === "INVALID_FILE_TYPE") {
    return Response.json(
      { message: "Invalid File Type", error: error.statusText, success: false },
      { status: 400, statusText: "Invalid File Type" },
    );
  }

  if (code === "UNKNOWN") {
    return Response.json(
      { message: error.message, error: error.statusText, success: false },
      { status: error.statusCode || 500, statusText: error.statusText || "Unknown Error" },
    );
  }

  if(error instanceof ErrorResponse){
    return Response.json(
      { message: error.message, error: error.statusText, success: false },
      { status: error.statusCode, statusText: error.statusText || "Unknown Error" },
    );
  }

  return Response.json(
    { message: "Something went wrong", error: "INTERNAL_SERVER_ERROR", success: false },
    { status: 500, statusText: "Internal Server Error" },
  );
};
