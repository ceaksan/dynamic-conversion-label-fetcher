___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Dynamic Conversion Label Fetcher",
  "description": "Fetch conversion labels based on domain-event conditions. Define mappings between store URLs and short names to return the corresponding label for streamlined tracking.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "condition",
    "displayName": "Define Domain-Event Condition",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SELECT",
        "name": "pickvariable",
        "displayName": "Matching Definition (Hostname, etc.)",
        "macrosInSelect": true,
        "selectItems": [],
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "pickevent",
        "displayName": "Conversion Event",
        "macrosInSelect": true,
        "selectItems": [],
        "simpleValueType": true
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "urltable",
        "displayName": "URL Definations",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Store URLs",
            "name": "storeUrls",
            "type": "TEXT",
            "isUnique": true,
            "valueHint": "Using http:// or https:// schema is optional. Ensure the URL matches the selected domain.",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Short name",
            "name": "shortnameforstore",
            "type": "TEXT",
            "valueHint": "Do not use any special characters. Keep it unique and short.",
            "isUnique": true,
            "valueValidators": [
              {
                "type": "TABLE_ROW_COUNT",
                "args": [
                  1,
                  10
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "PARAM_TABLE",
        "name": "conversions",
        "displayName": "Conversions",
        "paramTableColumns": [
          {
            "param": {
              "type": "SELECT",
              "name": "conversionevent",
              "displayName": "Conversion Event",
              "macrosInSelect": false,
              "selectItems": [
                {
                  "value": "page_view",
                  "displayValue": "page_view"
                },
                {
                  "value": "view_item",
                  "displayValue": "view_item"
                },
                {
                  "value": "add_to_cart",
                  "displayValue": "add_to_cart"
                },
                {
                  "value": "begin_checkout",
                  "displayValue": "begin_checkout"
                },
                {
                  "value": "purchase",
                  "displayValue": "purcahse"
                },
                {
                  "value": "sign_up",
                  "displayValue": "sign_up"
                },
                {
                  "value": "gtm.js",
                  "displayValue": "gtm.js"
                }
              ],
              "simpleValueType": true
            },
            "isUnique": false
          },
          {
            "param": {
              "type": "TEXT",
              "name": "conversionlabel",
              "displayName": "Conversion Label",
              "simpleValueType": true
            },
            "isUnique": true
          },
          {
            "param": {
              "type": "TEXT",
              "name": "shortname",
              "displayName": "Shortname",
              "simpleValueType": true
            },
            "isUnique": false
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Import the logToConsole API
// const log = require('logToConsole');

// Log the data object to the console
// log('data =', data);

// Main function to get the conversion label
function getConversionLabel(data) {
    // Check if data is defined
    if (!data) {
        // log('No data provided');
        return null;
    }

    // Access properties
    const pickvariable = data.pickvariable || null; // Use pickvariable for matching
    const pickevent = data.pickevent || null;
    const conversions = data.conversions || [];
    const urltable = data.urltable || []; // Default to an empty array if undefined
  
    // log('pickvariable', pickvariable);
    // log('pickevent', pickevent);
    // log('conversions', conversions);
    // log('urltable', urltable);
  
    // Find the entry in urltable that matches pickvariable
    let shortname = null;
    urltable.map(url => {
        // log('url.storeUrls', url.storeUrls);
        if (url.storeUrls === pickvariable) {
            shortname = url.shortnameforstore; // Get the corresponding short name
            // log('Matched shortname:', shortname);
        }
    });

    if (!shortname) {
        // log('No matching URL found for pickvariable:', pickvariable);
        return null; // No matching shortname found
    }

    // Find the conversion label based on the shortname and pickevent
    let conversionLabel = null;
    conversions.map(conversion => {
        // log('conversion.shortname', conversion.shortname);
        if (conversion.shortname === shortname && conversion.conversionevent === pickevent) {
            conversionLabel = conversion.conversionlabel; // Return the conversion label
            // log('Matched conversion label:', conversionLabel);
        }
    });

    return conversionLabel || null; // Return the conversion label or null if not found
}

// Call the function and return the result
const result = getConversionLabel(data);

// log('result', result);

// Variables must return a value.
return result || false; // Return the conversion label or false if not found


___TESTS___

scenarios: []


___NOTES___

Created on 1/11/2025, 10:08:09 PM


