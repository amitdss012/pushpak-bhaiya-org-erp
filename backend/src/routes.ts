import { Router } from "express";
import studentRoutes from "./module/students/routes/student.routes";

const router = Router();

router.use("/student", studentRoutes);

export default router;