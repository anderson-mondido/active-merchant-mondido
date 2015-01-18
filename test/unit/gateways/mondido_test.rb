require 'test_helper'

class MondidoTest < Test::Unit::TestCase
  def setup
    @gateway = MondidoGateway.new(
      merchant_id: "123",
      api_token: "test",
      hash_secret: "test"
    )

    @credit_card = credit_card
    @amount = 100

    @options = {
      order_id: '2000019661421604843208',
      test: true
    }
  end

  def parse(body)
    JSON.parse(body)
  end

  def test_successful_purchase
    @gateway.expects(:api_request).returns(parse(successful_purchase_response))
    @gateway.expects(:add_credit_card)

    response = @gateway.purchase(@amount, @credit_card, @options)
    assert_instance_of Response, response
    assert_success response

    assert_equal @options[:order_id], response.params["payment_ref"]
    assert response.test?
  end

  def test_failed_purchase
    @gateway.expects(:api_request).returns(parse(failed_purchase_response))

    response = @gateway.purchase(@amount, @credit_card, @options)
    assert_failure response
    assert_equal Gateway::STANDARD_ERROR_CODE[:card_declined], response.error_code
  end

  def test_successful_authorize
  end

  def test_failed_authorize
  end

  def test_successful_capture
  end

  def test_failed_capture
  end

  def test_successful_refund
  end

  def test_failed_refund
  end

  def test_successful_void
  end

  def test_failed_void
  end

  def test_successful_verify
  end

  def test_successful_verify_with_failed_void
  end

  def test_failed_verify
  end

  def test_scrub
    assert @gateway.supports_scrubbing?
    assert_equal @gateway.scrub(pre_scrubbed), post_scrubbed
  end

  private

  def pre_scrubbed
    <<-PRE_SCRUBBED
    opened
    starting SSL for api.mondido.com:443...
    SSL established
    <- "POST /v1/transactions HTTP/1.1\r\nAccept-Encoding: identity, identity\r\nAccept: */*\r\nUser-Agent: Ruby, Mondido ActiveMerchantBindings/1.45.0\r\nContent-Type: application/x-www-form-urlencoded\r\nAuthorization: Basic MTQ1OjEyMzA5dTE5dTEzdTkwMTIzdTkyMWRzYWRhZGdnZg==\r\nConnection: close\r\nHost: api.mondido.com\r\nContent-Length: 210\r\n\r\n"
    <- "amount=10.00&payment_ref=2000019661421607249995&currency=usd&hash=c7b0f2c6c1307fb3b524210039151df4&test=true&card_holder=Longbob+Longsen&card_cvv=200&card_expiry=0916&card_number=4111111111111111&card_type=visa"
    -> "HTTP/1.1 200 OK\r\n"
    -> "Access-Control-Allow-Headers: *\r\n"
    -> "Access-Control-Allow-Methods: POST, OPTIONS\r\n"
    -> "Access-Control-Allow-Origin: *\r\n"
    -> "Access-Control-Max-Age: 1728000\r\n"
    -> "Access-Control-Request-Method: *\r\n"
    -> "Cache-Control: max-age=0, private, must-revalidate\r\n"
    -> "Content-Type: application/json; charset=utf-8\r\n"
    -> "Date: Sun, 18 Jan 2015 18:54:11 GMT\r\n"
    -> "ETag: \"c7b38ffa17d6e400efe2446966a06922\"\r\n"
    -> "Server: Mondido\r\n"
    -> "Status: 200 OK\r\n"
    -> "Strict-Transport-Security: max-age=31536000\r\n"
    -> "X-Content-Type-Options: nosniff\r\n"
    -> "X-Frame-Options: SAMEORIGIN\r\n"
    -> "X-Powered-By: Mondido\r\n"
    -> "X-Request-Id: b9eaa1aa-4ca9-4bc4-84f7-f26f62a70ba3\r\n"
    -> "X-Runtime: 0.429664\r\n"
    -> "X-XSS-Protection: 1; mode=block\r\n"
    -> "transfer-encoding: chunked\r\n"
    -> "Connection: Close\r\n"
    -> "\r\n"
    -> "2c6\r\n"
    reading 710 bytes...
    -> "{\"id\":27892,\"created_at\":\"2015-01-18T18:54:11Z\",\"merchant_id\":145,\"amount\":\"10.0\",\"vat_amount\":null,\"payment_ref\":\"2000019661421607249995\",\"ref\":null,\"card_holder\":\"Longbob Longsen\",\"card_number\":\"411111******1111\",\"test\":true,\"metadata\":null,\"currency\":\"usd\",\"status\":\"approved\",\"card_type\":\"VISA\",\"transaction_type\":\"credit_card\",\"template_id\":null,\"error\":null,\"cost\":{\"percentual_fee\":\"0.025\",\"fixed_fee\":\"0.025\",\"percentual_exchange_fee\":\"0.035\",\"total\":\"0.625\"},\"success_url\":null,\"error_url\":null,\"items\":[],\"authorize\":false,\"href\":\"https://pay.mondido.com/v1/form/fD7k1_6u4HX27EJVHzzUQg\",\"stored_card\":null,\"customer\":null,\"subscription\":null,\"payment_details\":{\"id\":14540},\"refunds\":[],\"webhooks\":[]}"
    read 710 bytes
    reading 2 bytes...
    -> "\r\n"
    read 2 bytes
    -> "0\r\n"
    -> "\r\n"
    Conn close
     = 1.98 s
    PRE_SCRUBBED
  end

  def post_scrubbed
    <<-POST_SCRUBBED
    opened
    starting SSL for api.mondido.com:443...
    SSL established
    <- "POST /v1/transactions HTTP/1.1\r\nAccept-Encoding: identity, identity\r\nAccept: */*\r\nUser-Agent: Ruby, Mondido ActiveMerchantBindings/1.45.0\r\nContent-Type: application/x-www-form-urlencoded\r\nAuthorization: Basic [FILTERED]==\r\nConnection: close\r\nHost: api.mondido.com\r\nContent-Length: 210\r\n\r\n"
    <- "amount=[FILTERED].00&payment_ref=2000019661421607249995&currency=usd&hash=[FILTERED]&test=true&card_holder=[FILTERED]+Longsen&card_cvv=[FILTERED]&card_expiry=[FILTERED]&card_number=[FILTERED]&card_type=[FILTERED]"
    -> "HTTP/1.1 200 OK\r\n"
    -> "Access-Control-Allow-Headers: *\r\n"
    -> "Access-Control-Allow-Methods: POST, OPTIONS\r\n"
    -> "Access-Control-Allow-Origin: *\r\n"
    -> "Access-Control-Max-Age: 1728000\r\n"
    -> "Access-Control-Request-Method: *\r\n"
    -> "Cache-Control: max-age=0, private, must-revalidate\r\n"
    -> "Content-Type: application/json; charset=utf-8\r\n"
    -> "Date: Sun, 18 Jan 2015 18:54:11 GMT\r\n"
    -> "ETag: \"c7b38ffa17d6e400efe2446966a06922\"\r\n"
    -> "Server: Mondido\r\n"
    -> "Status: 200 OK\r\n"
    -> "Strict-Transport-Security: max-age=31536000\r\n"
    -> "X-Content-Type-Options: nosniff\r\n"
    -> "X-Frame-Options: SAMEORIGIN\r\n"
    -> "X-Powered-By: Mondido\r\n"
    -> "X-Request-Id: b9eaa1aa-4ca9-4bc4-84f7-f26f62a70ba3\r\n"
    -> "X-Runtime: 0.429664\r\n"
    -> "X-XSS-Protection: 1; mode=block\r\n"
    -> "transfer-encoding: chunked\r\n"
    -> "Connection: Close\r\n"
    -> "\r\n"
    -> "2c6\r\n"
    reading 710 bytes...
    -> "{\"id\":27892,\"created_at\":\"2015-01-18T18:54:11Z\",\"merchant_id\":145,\"amount\":\"10.0\",\"vat_amount\":null,\"payment_ref\":\"2000019661421607249995\",\"ref\":null,\"card_holder\":\"Longbob Longsen\",\"card_number\":\"411111******1111\",\"test\":true,\"metadata\":null,\"currency\":\"usd\",\"status\":\"approved\",\"card_type\":\"VISA\",\"transaction_type\":\"credit_card\",\"template_id\":null,\"error\":null,\"cost\":{\"percentual_fee\":\"0.025\",\"fixed_fee\":\"0.025\",\"percentual_exchange_fee\":\"0.035\",\"total\":\"0.625\"},\"success_url\":null,\"error_url\":null,\"items\":[],\"authorize\":false,\"href\":\"https://pay.mondido.com/v1/form/fD7k1_6u4HX27EJVHzzUQg\",\"stored_card\":null,\"customer\":null,\"subscription\":null,\"payment_details\":{\"id\":14540},\"refunds\":[],\"webhooks\":[]}"
    read 710 bytes
    reading 2 bytes...
    -> "\r\n"
    read 2 bytes
    -> "0\r\n"
    -> "\r\n"
    Conn close
     = 1.98 s
    POST_SCRUBBED
  end

  def successful_purchase_response
    <<-RESPONSE
    {
      "id": 27884,
      "created_at": "2015-01-18T18:14:04Z",
      "merchant_id": 145,
      "amount": "10.0",
      "vat_amount": null,
      "payment_ref": "2000019661421604843208",
      "ref": null,
      "card_holder": "Longbob Longsen",
      "card_number": "411111******1111",
      "test": true,
      "metadata": null,
      "currency": "usd",
      "status": "approved",
      "card_type": "VISA",
      "transaction_type": "credit_card",
      "template_id": null,
      "error": null,
      "cost": {
        "percentual_fee": "0.025",
        "fixed_fee": "0.025",
        "percentual_exchange_fee": "0.035",
        "total": "0.625"
      },
      "success_url": null,
      "error_url": null,
      "items": [

      ],
      "authorize": false,
      "href": "https://pay.mondido.com/v1/form/JaZbMJh5lV-jaB_HXv-S_A",
      "stored_card": null,
      "customer": null,
      "subscription": null,
      "payment_details": {
        "id": 14533
      },
      "refunds": [

      ],
      "webhooks": [

      ]
    }
    RESPONSE
  end

  def failed_purchase_response
    <<-RESPONSE
    {
      "name": "errors.payment.declined",
      "code": 129,
      "description": "Betalningen nekades"
    }
    RESPONSE
  end

  def successful_authorize_response
    <<-RESPONSE
    {
      "id": 27814,
      "created_at": "2015-01-18T16:52:33Z",
      "merchant_id": 145,
      "amount": "10.0",
      "vat_amount": null,
      "payment_ref": "2000046211421599952357",
      "ref": null,
      "card_holder": "Longbob Longsen",
      "card_number": "411111******1111",
      "test": true,
      "metadata": null,
      "currency": "usd",
      "status": "authorized",
      "card_type": "VISA",
      "transaction_type": "stored_card",
      "template_id": null,
      "error": null,
      "cost": {
        "percentual_fee": "0.025",
        "fixed_fee": "0.025",
        "percentual_exchange_fee": "0.035",
        "total": "0.625"
      },
      "success_url": null,
      "error_url": null,
      "items": [

      ],
      "authorize": true,
      "href": "https://pay.mondido.com/v1/form/kGrwU_vQIrm5ZTwUyLfpTA",
      "stored_card": {
        "id": 14857
      },
      "customer": {
        "id": 23922
      },
      "subscription": null,
      "payment_details": {
        "id": 14472
      },
      "refunds": [

      ],
      "webhooks": [

      ]
    }
    RESPONSE
  end

  def failed_authorize_response
    <<-RESPONSE
    {
      "name": "errors.payment.declined",
      "code": 129,
      "description": "Betalningen nekades"
    }
    RESPONSE
  end

  def successful_capture_response
    <<-RESPONSE
    {
      "id": 27785,
      "created_at": "2015-01-18T16:51:48Z",
      "merchant_id": 145,
      "amount": "5.0",
      "vat_amount": null,
      "payment_ref": "2000046211421599907148",
      "ref": null,
      "card_holder": "Longbob Longsen",
      "card_number": "411111******1111",
      "test": true,
      "metadata": null,
      "currency": "usd",
      "status": "approved",
      "card_type": "VISA",
      "transaction_type": "credit_card",
      "template_id": null,
      "error": null,
      "cost": {
        "percentual_fee": "0.025",
        "fixed_fee": "0.025",
        "percentual_exchange_fee": "0.035",
        "total": "0.325"
      },
      "success_url": null,
      "error_url": null,
      "items": [

      ],
      "authorize": true,
      "href": "https://pay.mondido.com/v1/form/obzEQfI3qaBggQekicRCbQ",
      "stored_card": null,
      "customer": {
        "id": 23958
      },
      "subscription": null,
      "payment_details": {
        "id": 14450
      },
      "refunds": [

      ],
      "webhooks": [

      ]
    }
    RESPONSE
  end

  def failed_capture_response
    <<-RESPONSE
    {
      "name": "errors.amount.invalid",
      "code": 109,
      "description": "amount är fel. Ska vara t.ex. 10.00"
    }
    RESPONSE
  end

  def successful_partial_refund_response
    <<-RESPONSE
    {
      "id": 1095,
      "created_at": "2015-01-18T16:51:53Z",
      "amount": "5.0",
      "reason": "Test",
      "ref": null,
      "transaction": {
        "id": 27786,
        "merchant_id": 145,
        "amount": "10.0",
        "currency": "usd",
        "metadata_old": null,
        "status": "approved",
        "created_at": "2015-01-18T16:51:51Z",
        "updated_at": "2015-01-18T16:51:51Z",
        "code": null,
        "message": null,
        "payment_request": {
          "hash": "517712249fb7e4a8682861ef99607c27",
          "test": "true",
          "amount": "10.00",
          "card_cvv": "200",
          "currency": "usd",
          "card_type": "VISA",
          "raw_amount": "10.00",
          "card_expiry": "0916",
          "card_holder": "Longbob Longsen",
          "card_number": "4111111111111111",
          "payment_ref": "2000046211421599910591",
          "customer_ref": "23922"
        },
        "test": true,
        "payment_info": {
        },
        "payment_response": null,
        "refund_response": null,
        "refund_amount": null,
        "template_id": null,
        "order_id": null,
        "card_number": "411111******1111",
        "card_holder": "Longbob Longsen",
        "card_type": "VISA",
        "raw_amount": "10.00",
        "error_message": null,
        "success_url": null,
        "error_url": null,
        "stored_card_id": null,
        "metadata_old2": null,
        "error_code": null,
        "error_name": null,
        "supported_card_json": "{\"percentual_fee\":\"0.025\",\"fixed_fee\":\"0.025\",\"percentual_exchange_fee\":\"0.035\"}",
        "subscription_id": null,
        "customer_id": 23958,
        "ref": null,
        "transaction_type": "credit_card",
        "payment_ref": "2000046211421599910591",
        "provider_ref": "54bbe4a7799",
        "metadata": null,
        "processed": true,
        "locked": false,
        "currency_converted_amount": "81.02357",
        "data": null,
        "vat_amount": null,
        "service_provider": "test_provider",
        "authorize": false,
        "authorization_id": 0,
        "href_token": "_iwPwZBXTA_TT_BXoQIITQ",
        "mpi_ref": null,
        "client_info": {
          "raw_user_agent": "Ruby, Mondido ActiveMerchantBindings/1.45.0",
          "browser": "Ruby,",
          "version": "",
          "platform": null,
          "ip": "201.81.64.127",
          "accept_language": null
        }
      }
    }
    RESPONSE
  end

  def successful_full_refund_response
    <<-RESPONSE
    {
      "id": 1096,
      "created_at": "2015-01-18T16:53:02Z",
      "amount": "10.0",
      "reason": "Test",
      "ref": null,
      "transaction": {
        "id": 27828,
        "merchant_id": 145,
        "amount": "10.0",
        "currency": "usd",
        "metadata_old": null,
        "status": "approved",
        "created_at": "2015-01-18T16:53:01Z",
        "updated_at": "2015-01-18T16:53:01Z",
        "code": null,
        "message": null,
        "payment_request": {
          "hash": "3c8162db632b77a76ea8e4d6848f23ca",
          "test": "true",
          "amount": "10.00",
          "extend": "transaction",
          "card_cvv": "200",
          "currency": "usd",
          "card_type": "VISA",
          "raw_amount": "10.00",
          "card_expiry": "0916",
          "card_holder": "Longbob Longsen",
          "card_number": "4111111111111111",
          "payment_ref": "2000046211421599979462",
          "customer_ref": "23922"
        },
        "test": true,
        "payment_info": {
        },
        "payment_response": null,
        "refund_response": null,
        "refund_amount": null,
        "template_id": null,
        "order_id": null,
        "card_number": "411111******1111",
        "card_holder": "Longbob Longsen",
        "card_type": "VISA",
        "raw_amount": "10.00",
        "error_message": null,
        "success_url": null,
        "error_url": null,
        "stored_card_id": null,
        "metadata_old2": null,
        "error_code": null,
        "error_name": null,
        "supported_card_json": "{\"percentual_fee\":\"0.025\",\"fixed_fee\":\"0.025\",\"percentual_exchange_fee\":\"0.035\"}",
        "subscription_id": null,
        "customer_id": 23958,
        "ref": null,
        "transaction_type": "credit_card",
        "payment_ref": "2000046211421599979462",
        "provider_ref": "54bbe4ed692",
        "metadata": null,
        "processed": true,
        "locked": false,
        "currency_converted_amount": "81.02357",
        "data": null,
        "vat_amount": null,
        "service_provider": "test_provider",
        "authorize": false,
        "authorization_id": 0,
        "href_token": "B8vsDse4CeS7aogizvDZwA",
        "mpi_ref": null,
        "client_info": {
          "raw_user_agent": "Ruby, Mondido ActiveMerchantBindings/1.45.0",
          "browser": "Ruby,",
          "version": "",
          "platform": null,
          "ip": "201.81.64.127",
          "accept_language": null
        }
      }
    }
  RESPONSE
  end

  def failed_refund_response
    <<-RESPONSE
    {
      "name": "errors.transaction.not_found",
      "code": 128,
      "description": "Transaktionen hittas inte"
    }
    RESPONSE
  end

  def successful_void_response
    <<-RESPONSE
    {
      "id": 1099,
      "created_at": "2015-01-18T16:54:30Z",
      "amount": "1.0",
      "reason": "Test",
      "ref": null,
      "transaction": {
        "id": 27872,
        "merchant_id": 145,
        "amount": "10.0",
        "currency": "usd",
        "metadata_old": null,
        "status": "authorized",
        "created_at": "2015-01-18T16:54:28Z",
        "updated_at": "2015-01-18T16:54:28Z",
        "code": null,
        "message": null,
        "payment_request": {
          "hash": "c609b4f9e225a2b8aec77d1d963cd9be",
          "test": "true",
          "amount": "10.00",
          "card_cvv": "200",
          "currency": "usd",
          "authorize": "true",
          "card_type": "VISA",
          "raw_amount": "10.00",
          "card_expiry": "0916",
          "card_holder": "Longbob Longsen",
          "card_number": "4111111111111111",
          "payment_ref": "2000046211421600067349",
          "customer_ref": "23922"
        },
        "test": true,
        "payment_info": {
        },
        "payment_response": null,
        "refund_response": null,
        "refund_amount": null,
        "template_id": null,
        "order_id": null,
        "card_number": "411111******1111",
        "card_holder": "Longbob Longsen",
        "card_type": "VISA",
        "raw_amount": "10.00",
        "error_message": null,
        "success_url": null,
        "error_url": null,
        "stored_card_id": null,
        "metadata_old2": null,
        "error_code": null,
        "error_name": null,
        "supported_card_json": "{\"percentual_fee\":\"0.025\",\"fixed_fee\":\"0.025\",\"percentual_exchange_fee\":\"0.035\"}",
        "subscription_id": null,
        "customer_id": 23958,
        "ref": null,
        "transaction_type": "credit_card",
        "payment_ref": "2000046211421600067349",
        "provider_ref": "54bbe544647",
        "metadata": null,
        "processed": true,
        "locked": false,
        "currency_converted_amount": "81.02357",
        "data": null,
        "vat_amount": null,
        "service_provider": "test_provider",
        "authorize": true,
        "authorization_id": 0,
        "href_token": "mayZ5kT5nSLnz14V7_UL0w",
        "mpi_ref": null,
        "client_info": {
          "raw_user_agent": "Ruby, Mondido ActiveMerchantBindings/1.45.0",
          "browser": "Ruby,",
          "version": "",
          "platform": null,
          "ip": "201.81.64.127",
          "accept_language": null
        }
      }
    }
    RESPONSE
  end

  def failed_void_response
    <<-RESPONSE
    {
      "name": "errors.transaction.not_found",
      "code": 128,
      "description": "Transaktionen hittas inte"
    }
    RESPONSE
  end

  def successful_store_response
    <<-RESPONSE
    {
      "id": 15168,
      "created_at": "2015-01-18T16:49:18Z",
      "token": "54bbe40e712",
      "card_holder": "Longbob Longsen",
      "card_number": "411111******1111",
      "status": "active",
      "currency": "SEK",
      "expires": "2016-09-30T23:59:59Z",
      "ref": null,
      "merchant_id": 145,
      "test": true,
      "customer": {
        "id": 24077
      }
    }
    RESPONSE
  end

  def failed_store_response
    <<-RESPONSE
    {
      "name": "errors.payment.declined",
      "code": 129,
      "description": "Betalningen nekades"
    }
    RESPONSE
  end

  def successful_unstore_response
    <<-RESPONSE
    {
      "id": 15192,
      "created_at": "2015-01-18T16:54:22Z",
      "token": "54bbe53e699",
      "card_holder": "Longbob Longsen",
      "card_number": "411111******1111",
      "status": "deleted",
      "currency": "SEK",
      "expires": "2016-09-30T23:59:59Z",
      "ref": null,
      "merchant_id": 145,
      "test": true,
      "customer": {
        "id": 24088
      }
    }
    RESPONSE
  end

  def failed_unstore_response
    <<-RESPONSE
    {
      "name": "errors.unexpected",
      "description": "Invalid response received from the Mondido API.\n  Please contact support@mondido.com if you continue to receive this message.\n  (The raw response returned by the API was #<Net::HTTPNotFound 404 Not Found readbody=true>)",
      "code": 133
    }
    RESPONSE
  end
end
