{% set cols = ['BOOKING_ID', 'BOOKING_DATE', 'NIGHTS_BOOKED'] %}
SELECT
    {% for col in cols %}
        {{ col }}

        {% if not loop.last %},
        {% endif %}
    {% endfor %}
FROM
    {{ ref('bronze_bookings') }}
