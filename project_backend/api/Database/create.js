import { DynamoDB } from "aws-sdk";




export const createRecord = async(params) => {

    try {
        const client = new DynamoDB.DocumentClient();
        let { error } = await client.put(params).promise();
        if (error) {
            console.log(error);
            return false;
        } else {
            return true;
        }


    } catch (e) {
        console.log(e);
        return false;
    }

};