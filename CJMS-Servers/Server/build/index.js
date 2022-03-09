"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const database_1 = require("./api/database/database");
const cjms_database = new database_1.Database();
const app = (0, express_1.default)();
const port = 2121;
const Test = 5;
exports.default = Test;
// var response = db.query(cjms_db.queryScripts.sql_get_users);
// if (response.results != null) {
//   console.log("Response");
//   console.log(response.results);
// }
// cjms_db.get_connection().query(cjms_db_api.queryScripts.get_sql_update_user("password", "testing", "user", "admin"), (err:any, result:any) => {
//   console.log(err);
// });
// cjms_db.query(cjms_db_api.queryScripts.get_sql_update_user("password", "testing", "user", "admin"));
// app.listen(port, () => {
//   console.log(`Server Running on port ${port}`);
// });
