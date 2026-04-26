import { cors } from "@elysiajs/cors";
import { logger } from "@grotto/logysia";
import { Elysia } from "elysia";
import { rateLimit } from "elysia-rate-limit";
import { errorHandler } from "./middlewares/error.middleware";
import router from "./routes";

const app = new Elysia()
  .use(logger({ logIP: true }))
  .use(
    cors({
      origin: "*",
      methods: ["GET", "POST", "PUT", "DELETE"],
      credentials: true,
    }),
  )
  .use(
    rateLimit({
      max: 200,
      duration: 60 * 1000, // 1 minute
      errorResponse: Response.json(
        { message: "Too many requests", success: false },
        { status: 429, statusText: "Too Many Requests" },
      ),
    }),
  )
  .onError(errorHandler);

app.get("/", () =>
  Response.json(
    { message: "Hello World", success: true },
    { status: 200, statusText: "OK" },
  ),
);

app.use(router);

export default app;
