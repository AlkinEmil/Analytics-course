create table dmshem_team.pinstats as (
    with orders as (
        select
            doc::json as dj
        from common.pinstats_dmshem
    ),
         parsed_orders as (
             select
                         dj ->> '_id'   as _id,
                         dj ->> 'user_id'   as user_id,
                         dj ->> 'offer_id'   as offer_id,
                         dj ->> 'order_id'   as order_id,
                         dj ->> 'selected_class'   as class,
                         (dj ->> 'created')::timestamp as created_dttm,
                         (dj ->> 'estimated_waiting')::timestamp as estimated_waiting,
                         (dj ->> 'estimated_waiting_ml')::timestamp as estimated_waiting_ml,
                         (dj -> 'geopoint' ->> 0)::decimal            as point_a_lon,
                         (dj -> 'geopoint' ->> 1)::decimal            as point_a_lat,
                         (dj ->> 'estimated_waiting_original')::timestamp as estimated_waiting_original

             from orders
         )
    select *
    from parsed_orders
);



create table dmshem_team.offers as (
    with offers as (
        select
            doc::json as dj
        from common.offers_dmshem
    ),
         parsed_offers as (
             select
                     dj ->> '_id'                   as offer_id,
                     dj ->> 'user_id'               as user_id,
                     (dj ->> 'created')::timestamp  as created_dttm,
                     (dj ->> 'due')::timestamp      as due,
                     (dj ->> 'time')::decimal       as time
             from offers
         )
    select *
    from parsed_offers
);



create table dmshem_team.orders_parsed as (
    with orders as (
        select
            doc::json as dj
        from common.order_proc_dmshem
    ),
         parsed_orders as (
             select
                         dj -> 'order' ->> 'city' as city,
                         dj -> 'order' -> 'request' ->> 'offer' as offer_id,
                         dj -> 'order' ->> 'status'                                                       as user_status,
                         dj -> 'order' ->> 'taxi_status'                                                  as driver_status,
                         dj ->> '_id'                                                                     as order_id,
                         dj -> 'performer' ->> 'driver_id'                                                as driver_id,
                         dj -> 'performer' ->> 'park_id'                                                  as park_id,
                         dj -> 'order' -> 'performer' ->> 'car'                                           as car_type,
                         dj -> 'order' -> 'performer' ->> 'driver_license'                                as driver_license,
                         dj -> 'order' -> 'performer' ->> 'car_number'                                    as car_number,
                         dj -> 'order' ->> 'user_id'                                                      as user_id,
                         (dj ->> 'created')::timestamp                                                    as created_dttm,
                         (dj -> 'order' ->> 'status_updated')::timestamp                                  as finished_dttm,
                         (dj -> 'order' -> 'feedback' ->> 'rating')::integer                               as rating,
                         (dj -> 'order' -> 'request' -> 'source' -> 'geopoint' ->> 0)::decimal            as point_a_lon,
                         (dj -> 'order' -> 'request' -> 'source' -> 'geopoint' ->> 1)::decimal            as point_a_lat,
                         (dj -> 'order' -> 'request' -> 'destinations' -> 0 -> 'geopoint' ->> 0)::decimal as point_b_lon,
                         (dj -> 'order' -> 'request' -> 'destinations' -> 0 -> 'geopoint' ->> 1)::decimal as point_b_lat,
                         (dj -> 'order' ->> 'cost')::decimal                                              as order_cost,
                         dj -> 'order' -> 'performer' -> 'tariff' ->> 'class'                             as performer_tariff,
                         dj -> 'order' -> 'request' -> 'class' ->> 0                                      as order_tariff,
                         dj -> 'order' -> 'billing_contract' ->> 'currency'                               as currency,
                         (dj -> 'order_info' -> 'statistics' -> 'status_updates'->1->>'c')::timestamp       as pending_time,
                         (dj -> 'order_info' -> 'statistics' -> 'status_updates'->3->>'c')::timestamp      as assignee_time,
                         (dj -> 'order_info' -> 'statistics' -> 'status_updates'->4->>'c')::timestamp      as arrival_time,
                         (dj -> 'order_info' -> 'statistics' -> 'status_updates'->5->>'c')::timestamp      as transporting_start_time,
                         (dj -> 'order_info' -> 'statistics' -> 'status_updates'->6->>'c')::timestamp      as transporting_end_time
             from orders
         )
    select *
    from parsed_orders
);



