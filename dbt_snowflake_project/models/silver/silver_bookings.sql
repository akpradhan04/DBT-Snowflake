{{ config(
    materialized = 'incremental',
    unique_key = 'BOOKING_ID'
) }}

SELECT
    booking_id,
    listing_id,
    booking_date,
    {{ multiply(
        'NIGHTS_BOOKED',
        'BOOKING_AMOUNT',
        2
    ) }} AS total_amount,
    service_fee,
    cleaning_fee,
    booking_status,
    created_at
FROM
    {{ ref('bronze_bookings') }}
