import { DynamoDB } from "aws-sdk";


export const readData = (params) => {

    const client = new DynamoDB.DocumentClient();
    return client.get(params).promise();



}