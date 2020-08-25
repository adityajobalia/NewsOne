import { readData } from "../../Database/read";
import { createToken } from "./JWTAuth";
export const isUserAlreadyRegistered = async(event, context, callback) => {

    try {
        let searchParams = {
            TableName: process.env.Users,
            Key: {
                userid: event.pathParameters.userid,
            },
        };
        let searchResult = await readData(searchParams);
        if (searchResult.Item !== undefined) {
            let jwtToken = createToken({ userid: searchResult.Item.userid, topics: searchResult.Item.topics });
            return {
                statusCode: 200,
                body: JSON.stringify({
                    code: 0,
                    data: {
                        isAlreadyRegister: true,
                        jwtToken: jwtToken,
                    },
                    message: "User Found"
                })
            }
        } else {
            return {
                statusCode: 200,
                body: JSON.stringify({
                    code: 0,
                    data: {
                        isAlreadyRegister: false,
                        jwtToken: "",
                    },
                    message: "No User Found"
                })
            }
        }

    } catch (err) {

        return {
            statusCode: 501,
            body: JSON.stringify({
                code: -1,
                data: {},
                message: err.message
            })
        }
    }

};