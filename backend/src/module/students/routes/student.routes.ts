import Elysia from "elysia";

const route = new Elysia({prefix: "/student"})

route.get("/", () => "Hello World");

export default route;