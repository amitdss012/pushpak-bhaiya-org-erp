import Elysia from "elysia";
import studentRoutes from "./module/students/routes/student.routes";

const route = new Elysia({ prefix: "/api/v1" });

route.use(studentRoutes);

export default route;