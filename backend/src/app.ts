import express from "express";
import cors from "cors";
import rateLimit from "express-rate-limit";
import { errorHandler } from "./middlewares/error.middleware";
import router from "./routes";

const app = express();

// Custom logger middleware (analogous to @grotto/logysia)
app.use((req, res, next) => {
  const start = Date.now();
  res.on("finish", () => {
    const duration = Date.now() - start;
    console.log(`[Request] ${req.method} ${req.originalUrl} - ${res.statusCode} (${duration}ms)`);
  });
  next();
});

// Parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// CORS
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true,
  }),
);

// Rate Limiter
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 200,
  message: { message: "Too many requests", success: false },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// Root route
app.get("/", (req, res) => {
  res.status(200).json({ message: "Hello World", success: true });
});

// API Routes (prefix: "/api/v1")
app.use("/api/v1", router);

// Error handler middleware (must be registered last)
app.use(errorHandler);

export default app;

