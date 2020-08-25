import { readData } from "../../Database/read";
import { verifyToken } from "./JWTAuth";
export const getUserDetails = async(event, context, callback) => {
    try {

        let user = verifyToken(event.headers["authToken"]);
        if (user === null || user === "error") {
            return {
                statusCode: 401,
                body: JSON.stringify({
                    code: -5,
                    data: {
                        user: {},
                        userId: ""
                    },
                    message: "Invalid Auth Token"
                })
            };
        }
        let params = {
            TableName: process.env.Users,
            Key: {
                userid: user.userid,
            },
        };

        let result = await readData(params);

        if (result) {
            callback(null, {
                statusCode: 200,
                body: JSON.stringify({
                    code: 0,
                    data: {
                        user: result.Item

                    },
                    message: "User Found"
                })
            })

        } else {
            callback(null, {
                statusCode: 200,
                body: JSON.stringify({
                    code: -2,
                    data: {
                        user: {},
                        userId: "",
                    },
                    message: "User Not Found"
                })
            })


        }



    } catch (e) {
        return {
            statusCode: 501,
            body: JSON.stringify({
                code: -1,
                data: {
                    user: {},
                    userId: ""
                },
                message: e.message
            })
        };
    }
};