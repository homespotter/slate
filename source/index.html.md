---
title: Boost Checkout API Reference

includes:
  - errors

search: true

code_clipboard: true
---

# Introduction

Through our SSO integration HomeSpotter powers a Boost check out process enabling third party vendors to seamlessly create and launch social media ads to promote listings. Using the provided url HomeSpotter automatically authenticates a user and populates data into the Boost check out process.

The Boost check out process allows the user to customize a pre-populated creative, confirm targeting, confirm budget and launch a campaign.

# Authentication

```php
   $token = JWT::encode(
            [
                'customer_id' => 1169,
                'agent_id' => '46576',
                'iat' => time()
            ],
            "shared_secret_key");

  $url . "&token=$token"
```

> Make sure to replace `shared_secret_key` with your API key.

Authentication uses a JWT Token sent along with the request as a url param.

The token consists of a payload with key/value pairs of the following values and then signed with the shared secret key.

| Parameter   | Description                                                                                                                        |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| agent_id    | The unique alphanumeric user_id for the user in the third party vendor’s system.                                                   |
| customer_id | The unique id known by the partner and HomeSpotter. 1169 should be used as the default/fallback.                                   |
| iat         | “issued at timestamp”. Tokens expire after 24 hours. Format is the numeric value representing the number of seconds from the epoch |

<aside class="notice">
  https://jwt.io/ is a helpful tool for creating JWT Tokens for testing. <a href="https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6IjExNjkiLCJhZ2VudF9pZCI6IjVjYmYzMmFmOTIxMjdkOTgxZDJlMWFkNiIsImlhdCI6MTU2NjkxODgwOX0.ROK388ADc9sxfYJnTOhvZWVd4wnI6-F5dBX8fJavc6g">Example Payload </a>.
</aside>

# Campaign Creation

There are slighty different query params for the listing and user depending on if HomeSpotter has a record for them respectively.

## Navigate to Boost Checkout

### HTTP Request

`GET https://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code>`

## Query Parameters

### Existing listings in HomeSpotter system

When HomeSpotter has the information on a listing you can just use the mls id and zip, otherwise refer to the following table for dynamically created listings.

```shell
  curl get "http://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code> \
  -d token=<token> \
  -d mls_id=abc123 \
  -d zip=55405
```

| Parameter | Description                                  |
| --------- | -------------------------------------------- |
| mls_id    | The MLS ID of the listing to be advertised   |
| zip       | The zip code of the listing to be advertised |

```shell
  curl get "http://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code> \
  -d token=<token> \
  -d mls_id=abc123 \
  -d zip=55405 \
  -d address=1601%20Willow%20Road \
  -d status=new \
  -d price=299999 \
  -d bed=2 \
  -d bath=3
```

### Listings not in HomeSpotter system

For listings HomeSpotter does not have information about you must also include the address and can then optionally include any other params found in this list. More information is better as they will get used in the ad when available.

| Parameter | Description                                                      |
| --------- | ---------------------------------------------------------------- |
| mls_id\*  | The MLS ID of the listing to be advertised                       |
| zip\*     | The zip code of the listing to be advertised                     |
| address\* | The street address of the listing to be advertised               |
| city      | The city of the listing to be advertised                         |
| state     | The zip code of the listing to be advertised                     |
| country   | The country of the listing                                       |
| price     | The price of the listing                                         |
| bed       | The number of beds of the listing                                |
| bath      | The number of baths of the listing                               |
| sqft      | The sqft of the listing to be advertised                         |
| desc      | The MLS description of the listing to be advertised              |
| latitude  | If not provided the zip will be used for geo targeting purposes. |
| longitude | If not provided the zip will be used for geo targeting purposes. |
| status    | Status of the listing, see available statuses table              |

<aside class="notice">
  * denotes a required field.
</aside>

### Available Statuses

The new, sold, and reducedprice status are indicated by a banner on the ad creative.

| Status       | Description                                                                           |
| ------------ | ------------------------------------------------------------------------------------- |
| new          | Property is newly available for sale.                                                 |
| rent         | Property is only available for rent.                                                  |
| pending      | Property has gone into a pending state.                                               |
| sold         | Property has been sold. A new campaign with sold status will create a 'Just Sold' ad. |
| reducedprice | Property has had a price reduction. This will create a “Price Reduced” ad campaign.   |
| closed       | Denotes a closed or off-market status.                                                |

<aside class="notice">
  Updating a listing to the sold or closed status will end any running campaigns associated with it.
</aside>

## Ad Creative Options

Ad creative options can be supplied for a new or existing listing, <bold>in the case of a new listing it is required to provide an img_url and listing_url.</bold>

| Status       | default              | Description                                                                  |
| ------------ | -------------------- | ---------------------------------------------------------------------------- |
| banner_color | 00a567 (Boost Green) | The hexadecimal color of the banner which displays the status.               |
| broker_name  | Boost By HomeSpotter | The name of the broker to use on the ad creative.                            |
| listing_url  | none                 | The URL where a user will be taken once they click on the ad.                |
| img_url      | none                 | The URL to the featured image for the property. Used as the image on the ad. |

## Agent Options

If the provided agent_id in the auth token does not match with an existing agent in the HomeSpotter system a new agent will be created with the provided agent variables. The agent_id in the token will be saved on the agent record to correctly identify the existing agent in the future.
These params override any existing agent info on the campaign creative so only should be passed when creating a new agent.

<aside class="notice">
  This will only apply to non-shared customer agents. Any shared customer agent that is not found in the HomeSpotter system will return an agent not found error.
</aside>

| Status       | Description                       |
| ------------ | --------------------------------- |
| first_name\* | The first name of the user.       |
| last_name\*  | The last name of the user.        |
| phone\*      | The phone number of the user.     |
| email        | The email address of the user.    |
| agent_img    | The image of the user for the ad. |

<aside class="notice">
  * denotes a required field.
</aside>
