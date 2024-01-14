import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

// Initialize firebase admin
initializeApp();

// Initialize firestore
const db = getFirestore();

/**
 * Generate a name from list of names and return it.
 * @param request - The request object.  Must contain a computerID.
 * @param response - The response object.
 * @returns The name.
 *
 * @example
 * ```ts
 * // Request
 * {
 *  "computerID": "3"
 * }
 * // or /generateName?computerID=3
 *
 * // Response
 * {
 * "name": "John"
 * }
 * ```
 */
export const generateName = onRequest((request, response) => {
  // Read from request
  let computerID = request.body.computerID;

  // If computerID not in body, read from query
  if (!computerID) {
    const computerIDQuery = request.query.computerID;
    if (typeof computerIDQuery === "string") {
      computerID = computerIDQuery;
    }
  }

  // If computerID is not provided, return error
  if (!computerID) {
    response.status(400).send("No computerID provided!");
    logger.error("No computerID provided!");
    return;
  }

  // Read list of names from firestore document
  // Document: shared/names with array of names in field "names"
  db.doc("shared/names")
    .get()
    .then((doc) => {
      // If document does not exist, return error
      if (!doc.exists) {
        response.status(500).send("No names document found!");
        logger.error("No names document found!");
        return;
      }

      // Read names from document
      const names = doc.data()?.names;

      // If names is not an array, return error
      if (!Array.isArray(names)) {
        response.status(500).send("Names is not an array!");
        logger.error("Names is not an array!");
        return;
      }

      // Get name from list of names
      const name = names[parseInt(computerID)];

      // If name is not a string, return error
      if (typeof name !== "string") {
        response.status(500).send("Name is not a string!");
        logger.error("Name is not a string!");
        return;
      }

      // Return name
      response.status(200).send({name: name});
      logger.info(`Name generated: ${name}`);
    })
    .catch((error) => {
      // Return error
      response.status(500).send(error);
      logger.error(error);
    });
});
