---
title: Boost Checkout API Reference

includes:

search: true

code_clipboard: true
---

# Introduction

Through our SSO integration HomeSpotter powers a Boost check out process enabling third party vendors to seamlessly create and launch social media ads to promote listings. Using the provided url HomeSpotter automatically authenticates a user and populates data into the Boost check out process.

The Boost check out process allows the user to customize a pre-populated creative, confirm targeting, confirm budget and launch a campaign.

# Boost Integration V2
Integration intended for partners without knowledge of current Boost customers.

## Authentication

```php
   $token = JWT::encode(
            [
                'partner_agent_id' => 123456789, // unique partner agent identifier
                'iss' => 'PARTNER_SHORT_CODE', // partner identifier
                'aud' => 'boost.homespotter.com', 
                'iat' => time() 
            ],
            "shared_secret_key"); 

  $url .= "&token=$token";
```

> Make sure to replace `shared_secret_key` with your API key.

Authentication uses a JWT Token sent along with the request as a url param.

The token consists of a payload with key/value pairs of the following values and then signed with the shared secret key.

| Parameter          | Description                                                                                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------                              |
| partner_agent_id   | The unique alphanumeric user_id for the respective user in the third party vendor’s system. Currently expecting ids less than 100 characters.                   |
| iss                | Issuer, partner identifier assigned by Boost to partner.                                                                                                        |    
| aud                | Audience, always boost.homespotter.com.                                                                                                                         |
| iat                | “issued at timestamp”. Tokens expire after 24 hours, can't be set in the future. Format is the numeric value representing the number of seconds from the epoch. |

<aside class="notice">
  https://jwt.io/ is a helpful tool for creating JWT Tokens for testing. <a href="https://jwt.io/#debugger-io?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjdXN0b21lcl9pZCI6IjExNjkiLCJhZ2VudF9pZCI6IjVjYmYzMmFmOTIxMjdkOTgxZDJlMWFkNiIsImlhdCI6MTU2NjkxODgwOX0.ROK388ADc9sxfYJnTOhvZWVd4wnI6-F5dBX8fJavc6g">Example Payload </a>.
</aside>

When an agent completes a purchase, they will get a HomeSpotter agent record. We will tie our internal HS agent record to the partner and partner_agent_id. Upon subsequent visits by the agent and when provided the same partner_agent_id they will be logged into their existing HS agent record.

## Domains
Production endpoints will use boost.homespotter.com.  QA/Staging endpoints are available upon request.

## Agent Promo Campaign Creation
The base url for campaign creation is as follows, note your partner short code will get swapped in for the last value in the path.
> https://DOMAIN/dashboard/integration/promo_campaign/PARTNER_SHORT_CODE?headline=My%20headline&title=My%20title&description=My%20Description&first_name=FIRST&last_name=LAST&broker_name=BROKER_NAME&phone=PHONE&email=EMAIL&facebook_page_id=FB_PAGE_ID&agent_img=IMG_URL&landing_page_url=LANDING_PAGE_URL&token=JWT_TOKEN

`GET https://boost.homespotter.com/dashboard/integration/promo_campaign/<partner_short_code>`

| Status       | Description                       |
| ------------ | --------------------------------- |
| first_name\* | The first name of the user (also used in agent creation if necessary).       |
| last_name\*  | The last name of the user (also used in agent creation if necessary).        |
| email\*      | The email address of the user (also used in agent creation if necessary).    |
| phone        | The phone number of the user (also used in agent creation if necessary).     |
| agent_img    | The image of the user for the ad (also used in agent creation if necessary). |
| facebook_page_id |  facebook page (MUST BE IN HS BUSINESS MANAGER) to post ad |
| headline     |  url encoded string to prepopulate ad headline  |
| title        |  url encoded string to prepopulate ad title |
| description  |  url encoded string to prepopulate ad description  |
| broker_name  |  url encoded string of brokerage to be used in ad  |
| landing_page_url |  url to ad landing page       |


<aside class="notice">
  * denotes a required field.
</aside>


## Leads+
The base url for Leads+ is as follows, note your partner short code will get swapped in for the last value in the path.
If the agent is new and has no Leads+ subscription it will send them to the purchase flow. 
If they do have a subscription, at this time they will be redirected to their Leads+ dashboard to manage, view leads, etc.
> https://DOMAIN/dashboard/integration/leads_plus/PARTNER_SHORT_CODE?first_name=FIRST&last_name=LAST&phone=PHONE&email=EMAIL&agent_img=IMG_URL&token=JWT_TOKEN

`GET https://boost.homespotter.com/dashboard/integration/leads_plus/<partner_short_code>`

| Status       | Description                       |
| ------------ | --------------------------------- |
| first_name\* | The first name of the user (also used in agent creation if necessary).       |
| last_name\*  | The last name of the user (also used in agent creation if necessary).        |
| email\*      | The email address of the user (also used in agent creation if necessary).    |
| phone        | The phone number of the user (also used in agent creation if necessary).     |
| agent_img    | The image of the user for the ad (also used in agent creation if necessary). |

<aside class="notice">
  * denotes a required field.
</aside>


## Listing Campaign Creation

There are slighty different query params for the listing and user depending on if HomeSpotter has a record for them respectively.

The base url for campaign creation is as follows, note your partner short code will get swapped in for the last value in the path.

`GET https://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code>`

### Query Parameters

#### Create listing ads in HomeSpotter system

When creating a listing ad, give as much information as possible about the listing. 
Boost will attempt to match the listing to a listing in our system by mls_id + zip or address + city + state.  
If Boost can't find the listing, then it will attempt to dynamically create the listing. 
More information is better as they will get used in the ad when available.

>Minimum acceptable (Only if listing and agent are known to already be in HomeSpotter system):

>https://DOMAIN/dashboard/integration/campaign/<partner_short_code>?token=<token>&mls_id=abc123&zip=55405


>Example where agent is known:

>https://DOMAIN/dashboard/integration/campaign/<partner_short_code>?token=<token>&mls_id=abc123&zip=55405&address=1601%20Willow%20Road&status=new&price=299999&bed=2&bath=3


>Example where agent and listing may not be in HomeSpotter system:

>https://DOMAIN/dashboard/integration/campaign/<partner_short_code>?token=<token>&mls_id=abc123&zip=55405&address=1601%20Willow%20Road&status=new&price=299999&bed=2&bath=3&first_name=Dwight&last_name=Schrute&phone=6126123445


| Parameter | Description                                                      |
| --------- | ---------------------------------------------------------------- |
| mls_id\*  | The MLS ID of the listing to be advertised                       |
| zip\*     | The zip code of the listing to be advertised                     |
| address\* | The street address of the listing to be advertised               |
| city      | The city of the listing to be advertised (provide if mls_id is not provided)|
| state     | The zip code of the listing to be advertised (provide if mls_id is not provided)|
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

#### Available Statuses

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

### Agent Options

If the provided agent_id in the auth token does not match with an existing agent in the HomeSpotter system a new agent will be created with the provided agent variables. The agent_id in the token will be saved on the agent record to correctly identify the existing agent in the future.
These params override any existing agent info on the campaign creative so only should be passed when creating a new agent.

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

### Ad Creative Options

Ad creative options can be supplied for a new or existing listing, in the case of a new listing it is required to provide an img_url and listing_url.

| Status        | default              | Description                                                                                               |
| ------------- | -------------------- | --------------------------------------------------------------------------------------------------------- |
| banner_color  | 00a567 (Boost Green) | The hexadecimal color of the banner which displays the status. # can be omitted, or url encode the value. |
| broker_name   | Boost By HomeSpotter | The name of the broker to use on the ad creative.                                                         |
| listing_url\* | none                 | The URL where a user will be taken once they click on the ad.                                             |
| img_url\*     | none                 | The URL to the featured image for the property. Used as the image on the ad.                              |
| facebook_page_id | HomeSpotter       |  facebook page (MUST BE IN HS BUSINESS MANAGER) to post ad |

<aside class="notice">
  * Required when its not an existing listing.
</aside>

## Agent Dashboard/Boost Introduction
For an existing agent in Boost, this integration can log them into their Boost dashboard. 
For agents that do not have accounts with Boost, they will be forwarded to a Boost Introduction page where they will be able to see the benefits of Boost. 
The will be able to create a listing or agent promotion ad.  
In this case, provide as much info about the agent as possible to make the introduction page a more agent specific experience.

>Minimum acceptable (Only agents with existing accounts):

>https://DOMAIN/dashboard/integration/dashboard/<partner_short_code>?token=JWT_TOKEN

>Typical use case: The base url for campaign creation is as follows, note your partner short code will get swapped in for the last value in the path.
If it seems they will want a listing ad, in addition to the info below, provide any listing information like that provided to the create listing endpoint (
mls_id, zip, address, city, state, country, price, bed, bath, sqft, desc, latitude, longitude, status, etc).

>https://DOMAIN/dashboard/integration/dashboard/PARTNER_SHORT_CODE?headline=My%20headline&title=My%20title&description=My%20Description&first_name=FIRST&last_name=LAST&broker_name=BROKER_NAME&phone=PHONE&email=EMAIL&facebook_page_id=FB_PAGE_ID&agent_img=IMG_URL&landing_page_url=LANDING_PAGE_URL&token=JWT_TOKEN


| Status       | Description                       |
| ------------ | --------------------------------- |
| first_name\* | The first name of the user (also used in agent creation if necessary).       |
| last_name\*  | The last name of the user (also used in agent creation if necessary).        |
| email\*      | The email address of the user (also used in agent creation if necessary).    |
| phone        | The phone number of the user (also used in agent creation if necessary).     |
| agent_img    | The image of the user for the ad (also used in agent creation if necessary). |
| facebook_page_id |  facebook page (MUST BE IN HS BUSINESS MANAGER) to post ad |
| headline     |  url encoded string to prepopulate ad headline  |
| title        |  url encoded string to prepopulate ad title |
| description  |  url encoded string to prepopulate ad description  |
| broker_name  |  url encoded string of brokerage to be used in ad  |
| landing_page_url |  url to ad landing page       |

<aside class="notice">
  * denotes a required field.
</aside>


To improve the experience for agents you can pass along their agent mls id and/or username.  
We can accept multiple mls agent identifiers.  
Append the following parameters indexed starting at 0 (current max is 5 identifiers).

>https://DOMAIN/dashboard/integration/dashboard/PARTNER_SHORT_CODE?first_name=FIRST&last_name=LAST&phone=PHONE&email=EMAIL&token=JWT_TOKEN&partner_mls_org_id0=CRMLS$reso_mls_org_id0=123456&agent_id_at_mls0=9877665&agent_username_at_mls0=akennedy&partner_mls_org_id0=AMLS$reso_mls_org_id0=123488&agent_id_at_mls0=9877444&agent_username_at_mls0=akennedy2

| Status       | Description                       |
| ------------ | --------------------------------- |
|partner_mls_org_id[i] | your identifier for the mls, ex CRMLS |
|reso_mls_org_id[i] | reso id                                  |
|agent_id_at_mls[i]* | agent mls id                            |
|agent_username_at_mls[i]* | agent username                    ||

<aside class="notice">
  * either agent_id_at_mls or agent_username_at_mls is required
</aside>


## Update Listing Endpoint
> https://boost.homespotter.com/dashboard/integration/update/$partner_short_code?token=$token&mls_id=785773599&zip=55401&price=99999

This will update the given summary based on the provided mls_id and zip with the other provided params. Right now any agent id passed into the token will work to update any listing, it doesn't have to be the agent that created the listing. The customer id has to be the same as the one that created the listing though.

All of the values that are used to create the summary can be updated, only exceptions are mls_id and zip which are used to determine which listing you want to change.

## Daily Stats Campaign Details Endpoint
> https://boost.homespotter.com/dashboard/integration/dailystats/$partner_short_code/yyyy-mm-dd?token=$token

The dailystats endpoint returns all stats for campaigns that were running on the provided date.

```json
{
  "date": "2020-08-25",
  "stats": [
    {
      "created_time_utc": "2020-04-29 16:31:37",
      "start_time_utc": "2020-04-29 16:36:37",
      "end_time_utc": "2020-08-29 16:31:37",
      "time_run": "838:59:59",
      "type": "AgentPromo",
      "campaign_id": "550195",
      "listing_id": null,
      "sub_type": "",
      "mls": "NA",
      "status": "Ended",
      "address": "95 Eliot Street",
      "city": "Milton",
      "state": "MA",
      "zip": "02186",
      "office_id": "34676",
      "office_name": "Milton",
      "audience": "New Campaign",
      "agent_name": "Beth Rooney",
      "payer": "agent-paid",
      "started_by": "Beth Rooney",
      "program": "manual",
      "product_name": "Agent Promo Subscription",
      "campaign_increased_exposure": "false",
      "landing_page_homespotter_powered": "No",
      "hs_landing_page_visits": "0",
      "pct_complete": "100.0000",
      "total_impressions": "320",
      "total_clicks": "0",
      "total_engagements": "0",
      "web_impressions": "320",
      "web_clicks": "0",
      "social_impressions": "0",
      "social_clicks": "0",
      "social_reach": "0",
      "social_frequency": "0.0000",
      "reactions": "0",
      "comments": "0",
      "page_likes": "0",
      "shares": "0",
      "information_requests_from_hs_landing_page": "0",
      "call_agent_from_hs_landing_page": "0",
      "email_agent_from_hs_landing_page": "0",
      "text_agent_from_hs_landing_page": "0",
      "download_app_from_hs_landing_page": "0",
      "get_directions_from_hs_landing_page": "0",
      "mortgage_preapproval_from_hs_landing_page": "0",
      "mortgage_calculator_loaded_from_hs_landing_page": "0",
      "address_unlocked_from_hs_landing_page": "0",
      "directions_unlocked_from_hs_landing_page": "0",
      "photos_unlocked_from_hs_landing_page": "0",
      "open_house_invite_from_hs_landing_page": "0",
      "facebook_ad_link": "https://rest.homespotter.com/campaign/adlink/loblaw/550195?type=facebook",
      "instagram_ad_link": "https://rest.homespotter.com/campaign/adlink/loblaw/550195?type=instagram",
      "landing_page_url": "https://www.loblaw.com/ledtraxform.asp?EFRM=CA",
      "video_p100_watched_actions": "0",
      "video_p95_watched_actions": "0",
      "video_p75_watched_actions": "0",
      "video_p50_watched_actions": "0",
      "video_p25_watched_actions": "0",
      "video_total_time_watched_seconds": "0",
      "video_avg_time_watched_seconds": "0.0000",
      "video_play_actions": "0"
    }
  ],
  "rows": "1"
}
```

## Campaign Details Endpoint
> https://boost.homespotter.com/dashboard/integration/details/$partner_short_code?token=$token

The details endpoint provides a report of the campaigns for the agent in the token.

```json
{
  "rollupStats": {
    "total_clicks": "393",
    "total_impressions": "6706",
    "total_campaigns": 1,
    "running_campaigns": "0"
  },
  "results": [
    {
      "campaign_id": "752145",
      "id": "752145",
      "customer_id": "1169",
      "boost_customer_id": "17555",
      "mls_number": "SR20243521",
      "type": "Listing",
      "starts_at": "2021-01-20 04:00:02",
      "ends_at": "2021-01-27 04:00:02",
      "headline": "Ready for a new home? Check out this 4 beds, 4 baths (3 partial) in Calabasas. 🏡🏡 Live the California dream in this spectacular, sprawling Spanish Hacienda! This private, gated estate is located on over an acre lot in the scenic Mulholland corridor, which is just a short drive from Malibu beach.…",
      "title": "4 bed, 4 bath (3 partial) in Calabasas",
      "description": "JUST LISTED",
      "image_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "image2_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--DqyJjq77--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_crop,g_center,h_536,w_824/c_scale,h_390,w_600/c_pad,g_north,h_500,w_600/e_replace_color:00A567:80:FF372D,l_display-ad_dpw2ya/c_fill,h_72,l_c6tnto7dedtx1jto7oyb,r_max,w_72,x_-249,y_200/c_fit,co_rgb:000,g_north_west,h_64,l_text:Open%20Sans_24_line_spacing_-4_left:Rodeo%2520Realty,w_306,x_104,y_457/co_rgb:000,g_north_west,l_text:Open%20Sans_24_left:David%2520Arcudi,x_104,y_415/co_rgb:fff,g_north,l_text:Open%20Sans_26_center:24325%2520Mulholland%252C%2520Calabasas,x_0,y_310/co_rgb:fff,g_north,l_text:Open%20Sans_26_bold_center:4%2520Beds%2520%257C%25204%2520Baths%2520%257C%2520%25242%252C500%252C000,x_0,y_345/c_scale,h_250,w_300/q_auto:best/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "listing_image_primary_text": "David Arcudi",
      "listing_image_secondary_text": "24325 Mulholland, Calabasas",
      "display_detail_text": "4 Beds | 4 Baths | $2,500,000",
      "social_ad_primary_text": "David Arcudi",
      "social_ad_secondary_text": "Rodeo Realty",
      "oh_starts_at": null,
      "oh_ends_at": null,
      "created_at": "2021-01-20 03:55:02",
      "updated_at": "2021-01-27 13:14:56",
      "address": "24325 Mulholland",
      "city": "Calabasas",
      "state": "CA",
      "zip": "91302",
      "price": "2500000",
      "agent_first_name": "David",
      "agent_last_name": "Arcudi",
      "agent_id": "4771432",
      "is_luxury": "0",
      "is_coming_soon": "0",
      "is_recently_sold": "0",
      "is_price_reduced": "0",
      "llp_link": "http://davidarcudi.rodeore.com/residential/crm/364979303/24325-mulholland-calabasas-ca-91302",
      "source": "manual",
      "partner": "Spacio",
      "campaign_status": "Enabled",
      "payer_label": "Agent Paid",
      "listing_id": "364979303",
      "raw_photo_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "display_status": "Enabled",
      "display_type": "Listing",
      "impressions": "6706",
      "clicks": "393",
      "engaged": "2",
      "time_viewed": "0",
      "video_plays": "0"
    }
  ],
  "rows": "1"
}
```

## Check if an agent already exists in Boost
> https://api.homespotter.com/graphql

To check whether an agent has already been linked to a Boost account, a GraphQL request is used. Note that the server in this case is `api.homespotter.com`.

The `graphql_api_secret_token` used in this request is not the same as the token used for requests to `boost.homespotter.com` and will be provided to you by the Boost team.

> Sample Request

```shell
curl --request POST \
  --url https://api.homespotter.com/graphql \
  --header 'Authorization: Bearer [graphql_api_secret_token]' \
  --header 'Content-Type: application/json' \
  --data '{"query":"query Agents($partnerShortCode: String, $partnerAgentId: ID!) {
    agents(partnerShortCode: $partnerShortCode, partnerAgentId: $partnerAgentId, pagination: {first: 1}) {
    totalCount
      list {
        firstName
        lastName
        emailAddress
      }
    }
}
","variables":{"partnerShortCode":"your partner short code","partnerAgentId":"gi1630340897553"},"operationName":"Agents"}'
```

> Sample Response

```
200 OK
```
```json
{
  "data": {
    "agents": {
      "list": [
        {
          "emailAddress": "launchpad_1632558874495@email.com",
          "firstName": "Beth",
          "lastName": "Rooney"
        }
      ],
      "totalCount": 1
    }
  }
}
```

# Boost Integration V1
This integration is meant for partners that have a familiarity with our current Boost Customers.

## Authentication

```php
   $token = JWT::encode(
            [
                'customer_id' => 1169,
                'agent_id' => '46576',
                'iat' => time()
            ],
            "shared_secret_key");

  $url .= "&token=$token";
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

## Campaign Creation

There are slighty different query params for the listing and user depending on if HomeSpotter has a record for them respectively.

The base url for campaign creation is as follows, note your partner short code will get swapped in for the last value in the path.

`GET https://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code>`

### Query Parameters

#### Existing listings in HomeSpotter system

When HomeSpotter has the information on a listing you can just use the mls id and zip, otherwise refer to the following table for dynamically created listings.

```shell
  curl get "https://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code> \
  -d token=<token> \
  -d mls_id=abc123 \
  -d zip=55405
```

| Parameter | Description                                  |
| --------- | -------------------------------------------- |
| mls_id    | The MLS ID of the listing to be advertised   |
| zip       | The zip code of the listing to be advertised |

```shell
  curl get "https://boost.homespotter.com/dashboard/integration/campaign/<partner_short_code>?token=<token>&mls_id=abc123&zip=55405&address=1601%20Willow%20Road&status=new&price=299999&bed=2&bath=3"
```

#### Listings not in HomeSpotter system

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

#### Available Statuses

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

### Ad Creative Options

Ad creative options can be supplied for a new or existing listing, in the case of a new listing it is required to provide an img_url and listing_url.

| Status        | default              | Description                                                                                               |
| ------------- | -------------------- | --------------------------------------------------------------------------------------------------------- |
| banner_color  | 00a567 (Boost Green) | The hexadecimal color of the banner which displays the status. # can be omitted, or url encode the value. |
| broker_name   | Boost By HomeSpotter | The name of the broker to use on the ad creative.                                                         |
| listing_url\* | none                 | The URL where a user will be taken once they click on the ad.                                             |
| img_url\*     | none                 | The URL to the featured image for the property. Used as the image on the ad.                              |

<aside class="notice">
  * Required when its not an existing listing.
</aside>

### Agent Options

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

## Reporting and Stats Endpoints

### All Campaign Details

The all endpoint provides a report of all campaigns created via the integration, this includes a rollup and details on each campaign. Any valid agent id can be used in the token.

> https://boost.homespotter.com/dashboard/integration/all/$partner_short_code?token=$token

```json
{
  "rollupStats": {
    "total_clicks": "7002",
    "total_impressions": "176712",
    "total_campaigns": 53,
    "running_campaigns": "0"
  },
  "results": [
    {
      "campaign_id": "752145",
      "id": "752145",
      "customer_id": "1169",
      "boost_customer_id": "17555",
      "mls_number": "SR20243521",
      "type": "Listing",
      "starts_at": "2021-01-20 04:00:02",
      "ends_at": "2021-01-27 04:00:02",
      "headline": "Ready for a new home? Check out this 4 beds, 4 baths (3 partial) in Calabasas. 🏡🏡 Live the California dream in this spectacular, sprawling Spanish Hacienda! This private, gated estate is located on over an acre lot in the scenic Mulholland corridor, which is just a short drive from Malibu beach.…",
      "title": "4 bed, 4 bath (3 partial) in Calabasas",
      "description": "JUST LISTED",
      "image_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "image2_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--DqyJjq77--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_crop,g_center,h_536,w_824/c_scale,h_390,w_600/c_pad,g_north,h_500,w_600/e_replace_color:00A567:80:FF372D,l_display-ad_dpw2ya/c_fill,h_72,l_c6tnto7dedtx1jto7oyb,r_max,w_72,x_-249,y_200/c_fit,co_rgb:000,g_north_west,h_64,l_text:Open%20Sans_24_line_spacing_-4_left:Rodeo%2520Realty,w_306,x_104,y_457/co_rgb:000,g_north_west,l_text:Open%20Sans_24_left:David%2520Arcudi,x_104,y_415/co_rgb:fff,g_north,l_text:Open%20Sans_26_center:24325%2520Mulholland%252C%2520Calabasas,x_0,y_310/co_rgb:fff,g_north,l_text:Open%20Sans_26_bold_center:4%2520Beds%2520%257C%25204%2520Baths%2520%257C%2520%25242%252C500%252C000,x_0,y_345/c_scale,h_250,w_300/q_auto:best/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "listing_image_primary_text": "David Arcudi",
      "listing_image_secondary_text": "24325 Mulholland, Calabasas",
      "display_detail_text": "4 Beds | 4 Baths | $2,500,000",
      "social_ad_primary_text": "David Arcudi",
      "social_ad_secondary_text": "Rodeo Realty",
      "oh_starts_at": null,
      "oh_ends_at": null,
      "created_at": "2021-01-20 03:55:02",
      "updated_at": "2021-01-27 13:14:56",
      "address": "24325 Mulholland",
      "city": "Calabasas",
      "state": "CA",
      "zip": "91302",
      "price": "2500000",
      "agent_first_name": "David",
      "agent_last_name": "Arcudi",
      "agent_id": "4771432",
      "is_luxury": "0",
      "is_coming_soon": "0",
      "is_recently_sold": "0",
      "is_price_reduced": "0",
      "llp_link": "http://davidarcudi.rodeore.com/residential/crm/364979303/24325-mulholland-calabasas-ca-91302",
      "source": "manual",
      "partner": "Spacio",
      "campaign_status": "Enabled",
      "payer_label": "Agent Paid",
      "listing_id": "364979303",
      "raw_photo_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "display_status": "Enabled",
      "display_type": "Listing",
      "impressions": "6706",
      "clicks": "393",
      "engaged": "2",
      "time_viewed": "0",
      "video_plays": "0"
    }
  ],
  "rows": "1"
}
```

### Daily Stats Campaign Details Endpoint

The dailystats endpoint returns all stats for campaigns that were running on the provided date.

> https://boost.homespotter.com/dashboard/integration/dailystats/$partner_short_code/yyyy-mm-dd?token=$token

```json
{
  "date": "2020-08-25",
  "stats": [
    {
      "created_time_utc": "2020-04-29 16:31:37",
      "start_time_utc": "2020-04-29 16:36:37",
      "end_time_utc": "2020-08-29 16:31:37",
      "time_run": "838:59:59",
      "type": "AgentPromo",
      "campaign_id": "550195",
      "listing_id": null,
      "sub_type": "",
      "mls": "NA",
      "status": "Ended",
      "address": "95 Eliot Street",
      "city": "Milton",
      "state": "MA",
      "zip": "02186",
      "office_id": "34676",
      "office_name": "Milton",
      "audience": "New Campaign",
      "agent_name": "Beth Rooney",
      "payer": "agent-paid",
      "started_by": "Beth Rooney",
      "program": "manual",
      "product_name": "Agent Promo Subscription",
      "campaign_increased_exposure": "false",
      "landing_page_homespotter_powered": "No",
      "hs_landing_page_visits": "0",
      "pct_complete": "100.0000",
      "total_impressions": "320",
      "total_clicks": "0",
      "total_engagements": "0",
      "web_impressions": "320",
      "web_clicks": "0",
      "social_impressions": "0",
      "social_clicks": "0",
      "social_reach": "0",
      "social_frequency": "0.0000",
      "reactions": "0",
      "comments": "0",
      "page_likes": "0",
      "shares": "0",
      "information_requests_from_hs_landing_page": "0",
      "call_agent_from_hs_landing_page": "0",
      "email_agent_from_hs_landing_page": "0",
      "text_agent_from_hs_landing_page": "0",
      "download_app_from_hs_landing_page": "0",
      "get_directions_from_hs_landing_page": "0",
      "mortgage_preapproval_from_hs_landing_page": "0",
      "mortgage_calculator_loaded_from_hs_landing_page": "0",
      "address_unlocked_from_hs_landing_page": "0",
      "directions_unlocked_from_hs_landing_page": "0",
      "photos_unlocked_from_hs_landing_page": "0",
      "open_house_invite_from_hs_landing_page": "0",
      "facebook_ad_link": "https://rest.homespotter.com/campaign/adlink/loblaw/550195?type=facebook",
      "instagram_ad_link": "https://rest.homespotter.com/campaign/adlink/loblaw/550195?type=instagram",
      "landing_page_url": "https://www.loblaw.com/ledtraxform.asp?EFRM=CA",
      "video_p100_watched_actions": "0",
      "video_p95_watched_actions": "0",
      "video_p75_watched_actions": "0",
      "video_p50_watched_actions": "0",
      "video_p25_watched_actions": "0",
      "video_total_time_watched_seconds": "0",
      "video_avg_time_watched_seconds": "0.0000",
      "video_play_actions": "0"
    }
  ],
  "rows": "1"
}
```

### Campaign Details Endpoint

The details endpoint provides a report of the campaigns for the agent in the token.

> https://boost.homespotter.com/dashboard/integration/details/$partner_short_code?token=$token

```json
{
  "rollupStats": {
    "total_clicks": "393",
    "total_impressions": "6706",
    "total_campaigns": 1,
    "running_campaigns": "0"
  },
  "results": [
    {
      "campaign_id": "752145",
      "id": "752145",
      "customer_id": "1169",
      "boost_customer_id": "17555",
      "mls_number": "SR20243521",
      "type": "Listing",
      "starts_at": "2021-01-20 04:00:02",
      "ends_at": "2021-01-27 04:00:02",
      "headline": "Ready for a new home? Check out this 4 beds, 4 baths (3 partial) in Calabasas. 🏡🏡 Live the California dream in this spectacular, sprawling Spanish Hacienda! This private, gated estate is located on over an acre lot in the scenic Mulholland corridor, which is just a short drive from Malibu beach.…",
      "title": "4 bed, 4 bath (3 partial) in Calabasas",
      "description": "JUST LISTED",
      "image_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "image2_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--DqyJjq77--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_crop,g_center,h_536,w_824/c_scale,h_390,w_600/c_pad,g_north,h_500,w_600/e_replace_color:00A567:80:FF372D,l_display-ad_dpw2ya/c_fill,h_72,l_c6tnto7dedtx1jto7oyb,r_max,w_72,x_-249,y_200/c_fit,co_rgb:000,g_north_west,h_64,l_text:Open%20Sans_24_line_spacing_-4_left:Rodeo%2520Realty,w_306,x_104,y_457/co_rgb:000,g_north_west,l_text:Open%20Sans_24_left:David%2520Arcudi,x_104,y_415/co_rgb:fff,g_north,l_text:Open%20Sans_26_center:24325%2520Mulholland%252C%2520Calabasas,x_0,y_310/co_rgb:fff,g_north,l_text:Open%20Sans_26_bold_center:4%2520Beds%2520%257C%25204%2520Baths%2520%257C%2520%25242%252C500%252C000,x_0,y_345/c_scale,h_250,w_300/q_auto:best/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "listing_image_primary_text": "David Arcudi",
      "listing_image_secondary_text": "24325 Mulholland, Calabasas",
      "display_detail_text": "4 Beds | 4 Baths | $2,500,000",
      "social_ad_primary_text": "David Arcudi",
      "social_ad_secondary_text": "Rodeo Realty",
      "oh_starts_at": null,
      "oh_ends_at": null,
      "created_at": "2021-01-20 03:55:02",
      "updated_at": "2021-01-27 13:14:56",
      "address": "24325 Mulholland",
      "city": "Calabasas",
      "state": "CA",
      "zip": "91302",
      "price": "2500000",
      "agent_first_name": "David",
      "agent_last_name": "Arcudi",
      "agent_id": "4771432",
      "is_luxury": "0",
      "is_coming_soon": "0",
      "is_recently_sold": "0",
      "is_price_reduced": "0",
      "llp_link": "http://davidarcudi.rodeore.com/residential/crm/364979303/24325-mulholland-calabasas-ca-91302",
      "source": "manual",
      "partner": "Spacio",
      "campaign_status": "Enabled",
      "payer_label": "Agent Paid",
      "listing_id": "364979303",
      "raw_photo_url": "https://res.cloudinary.com/davszpppo/image/fetch/s--m1uBrH3g--/g_center,h_768,w_1024/c_crop,g_south,h_653,w_1024/c_crop,g_north,h_536,w_1024/c_scale,h_628,w_1200/l_fb_boost_overlay1_gradient_szmesb/l_fb_boost_overlay1_agent_photo_background_r70bwp/c_fill,h_154,l_c6tnto7dedtx1jto7oyb,r_max,w_154,x_-493,y_207/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:David%2520Arcudi,x_205,y_108/co_rgb:fff,g_south_west,l_text:Open%20Sans_40_bold_left:Rodeo%2520Realty,x_205,y_58/http://public.rodeore.com/ROD_PUBLIC/MLSPhotos/CRMIDX/364979303_1.jpg",
      "display_status": "Enabled",
      "display_type": "Listing",
      "impressions": "6706",
      "clicks": "393",
      "engaged": "2",
      "time_viewed": "0",
      "video_plays": "0"
    }
  ],
  "rows": "1"
}
```

### Update Listing Endpoint

This will update the given summary based on the provided mls_id and zip with the other provided params. Right now any agent id passed into the token will work to update any listing, it doesn't have to be the agent that created the listing. The customer id has to be the same as the one that created the listing though.

All of the values that are used to create the summary can be updated, only exceptions are mls_id and zip which are used to determine which listing you want to change.

> https://boost.homespotter.com/dashboard/integration/update/$partner_short_code?token=$token&mls_id=785773599&zip=55401&price=99999




# Zapier Integration

## Zapier Webhook API Documentation
Base URL: https://rest.homespotter.com/zapier_webhook/<br>
Authentication: API Key (passed in request parameters or body)

🔐 Authentication
All endpoints require an api_key for authentication. The key must be passed in either:<br>
•       Query parameters (for GET and DELETE)<br>
•       Request body (for POST)<br>
## 📬 Endpoints
### POST /subscribe
Description: 
Creates a new webhook subscription for a Zapier workflow.<br>

```
curl --location 'https://rest.homespotter.com/zapier_webhook/subscribe' \
--header 'Content-Type: application/json' \
--data '{
	"hook_url": "https://hooks.zapier.com/hooks/catch/123456/abcde",
	"product_id": "abc123",
	"api_key": "your_api_key_here"
}'
```
Body:<br/>
•       api_key: Your API key (required)<br>
•       hook_url: (required)<br>
•       product_id: (required)<br>

### DELETE /unsubscribe
Description: 
Removes an existing webhook subscription.<br>

```
curl --location --request DELETE 'https://rest.homespotter.com/zapier_webhook/unsubscribe?api_key=your_api_key_here'<br>
```

Parameters:<br/>
•       api_key: Your API key (required)<br>


### GET /sample_data
Description: 
Returns sample data useful for Zap setup and testing.<br>

```
curl --location 'https://rest.homespotter.com/zapier_webhook/sample_data?api_key=your_api_key&productId=abc123'
```

Parameters (Query):<br>
•       api_key: Your API key (required)<br>
•       productId: Product identifier (required)<br>

### GET /me
Description: 
Validates the provided API key and returns account-related info.<br/>

```
curl --location 'https://rest.homespotter.com/zapier_webhook/me?api_key=your_api_key_here'
```

Parameters (Query):<br/>
•       api_key: Your API key (required)<br/>

### Success Response:

```json
{
	"status": "success",
	"message": ""
}
```
<br/>
<br/>
<br/>

### ❗ Error Handling<br>
<table> <tr><th>Status</th> <th>Code</th><th>Meaning</th><th>Notes</th></tr>
<tr><td>200</td><td>OK</td><td>Request</td><td>succeeded</td><td></td></tr>
<tr><td>400</td><td>Bad Request</td><td>Missing or malformed parameters</td><td></td></tr>
<tr><td>401	<td>Unauthorized</td>	<td>Invalid or missing API key</td><td></td></tr>
<tr><td>404	<td>Not Found</td>	<td>Endpoint not found or invalid URL</td><td></td></tr>
<tr><td>500	<td>Server Error</td>	<td>Unexpected issue on server</td><td></td></tr>
</table>

 
