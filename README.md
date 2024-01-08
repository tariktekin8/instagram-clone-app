# BOPF (Business Object Processing Framework)

# What is BOPF?

- BOPF is an ABAP OO-based framework that allows developers to build and manage business objects in an efficient and standardized way.
- It manages the entire life cycle of your business objects and covers all aspects of your business application development.
- Instead of expending effort for developing an application infrastructure, the developer can focus on the individual business logic.

# Which modules use BOPF?

- Transportation Management
- Environment, Health and Safety
- Supplier Lifecycle Management
- Management of Change
- Quality Issue Management

# BOPF API Overview

We need to use interfaces below to perform most of the operations within the BOPF API.

![API Infrastructure](https://blogs.sap.com/wp-content/uploads/2013/01/bopfclassdiagram_175221.png)

API Infrastructure

## **/BOBF/IF_TRA_SERVICE_MANAGER**

The service manager object reference provides us with the methods we need to lookup BO nodes, update BO nodes, trigger validations, perform actions, and so on.

### Determination

A determination is an entity of a business object node that is used to provide functions that are automatically executed as soon as a certain trigger condition is fulfilled. A determination is triggered internally on the basis of changes made to the node instance of a business object.

Categories for determination;

**Transient Determination →** Modifies only transient fields or nodes. For such determinations no locking is necessary.

**Persistent Determination →** Modifies transient and persistent fields or nodes. Here locking is necessary.

Determination dependencies restrict the order, in which the trigger conditions are evaluated. Dependency defines the execution order of determinations:

**Necessary Determinations →** Determinations, which have to been executed before by the framework.

**Dependent Determinations →** Determinations that are dependent on the other determination created.

![Determination](BOPF%20(Business%20Object%20Processing%20Framework)%20deac64e541824a7bb0ec93d379366081/Untitled.png)

Determination

![Trigger condition of nodes](BOPF%20(Business%20Object%20Processing%20Framework)%20deac64e541824a7bb0ec93d379366081/Untitled%201.png)

Trigger condition of nodes

![Determination execution times](BOPF%20(Business%20Object%20Processing%20Framework)%20deac64e541824a7bb0ec93d379366081/Untitled%202.png)

Determination execution times

![Determination dependencies](BOPF%20(Business%20Object%20Processing%20Framework)%20deac64e541824a7bb0ec93d379366081/Untitled%203.png)

Determination dependencies

### Retrieve

`RETRIEVE( )` method can provide data related to a node or can be used to lock record of a node.

```abap
DATA(service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

DATA(keys) = VALUE /bobf/t_frw_key( ).
DATA(root_table) = VALUE /scmtms/t_tor_root_k( ).

TRY.
    service_manager->retrieve(
      EXPORTING
        it_key        = keys
        iv_node_key   = /scmtms/if_tor_c=>sc_node-root
        iv_edit_mode  = /bobf/if_conf_c=>sc_edit_exclusive "Exclusive mode locks node
        iv_fill_data  = abap_true
      IMPORTING
        et_data       = root_table
        et_failed_key = DATA(failed_keys)
        eo_message    = DATA(message) ).
  CATCH /bobf/cx_frw_contrct_violation INTO DATA(contrct_violation).
ENDTRY.
```

### Retrieve by association

`RETRIEVE_BY_ASSOCIATION( )` method quite similar to `RETRIEVE( )` method. It has used to get node data with associated node which has defined in BO before. You can use code below if you need to get item data of root.

```abap
DATA(service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

DATA(keys) = VALUE /bobf/t_frw_key( ).
DATA(item_table) = VALUE /scmtms/t_tor_item_k( ).

TRY.
    service_manager->retrieve_by_association(
      EXPORTING
        it_key         = keys
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_fill_data   = abap_true
        iv_edit_mode   = /bobf/if_conf_c=>sc_edit_read_only
      IMPORTING
        eo_message     = DATA(message)
        eo_change      = DATA(change)
        et_data        = item_table
        et_key_link    = DATA(key_link)
        et_target_key  = DATA(target_key)
        et_failed_key  = DATA(failed_key) ).
  CATCH /bobf/cx_frw_contrct_violation INTO DATA(contrct_violation).
ENDTRY.
```

### Modify

`MODIFY( )` method provide operations like insert, update, and delete on a record for a node.

```abap
DATA(service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

DATA(keys) = VALUE /bobf/t_frw_key( ).

TRY.
    tor_service_manager->retrieve(
      EXPORTING
        iv_node_key  = /scmtms/if_tor_c=>sc_node-item_tr
        it_key       = keys
        iv_edit_mode = /bobf/if_conf_c=>sc_edit_exclusive
        iv_fill_data = abap_false
      IMPORTING
        eo_message   = DATA(message) ).

    DATA(item_tr) = VALUE /scmtms/s_tor_item_tr_k( amt_gdsv_val     = amount
                                                   amt_gdsv_cur     = currency ).

    DATA(modification_table) = VALUE /bobf/t_frw_modification( ( change_mode    = /bobf/if_frw_c=>sc_modify_update
                                                                 node           = /scmtms/if_tor_c=>sc_node-item_tr
                                                                 key            = key
                                                                 data           = REF #( data )
                                                                 changed_fields = VALUE #( ( /scmtms/if_tor_c=>sc_node_attribute-item_tr-amt_gdsv_val )
                                                                                           ( /scmtms/if_tor_c=>sc_node_attribute-item_tr-amt_gdsv_cur ) ) ) ).

    tor_service_manager->modify(
      EXPORTING
        it_modification = modification_table
      IMPORTING
        eo_message      = message ).

  CATCH /bobf/cx_frw_contrct_violation INTO DATA(frw_contrct_violation).
    RAISE EXCEPTION frw_contrct_violation.
ENDTRY.
```

### Query

`QUERY( )` method provides bunch of data with using own selection parameters table dynamically.

```abap
DATA(service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

DATA(lt_selection_parameters) = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_node_attribute-item_tr-item_cat
                                                                    sign           = 'I'
                                                                    option         = 'EQ'
                                                                    low            = 'PRD'  ) ).

service_manager->query(
  EXPORTING
    iv_query_key            = /scmtms/if_tor_c=>sc_query-item_tr-qdb_query_by_attributes
    it_selection_parameters = lt_selection_parameters
  IMPORTING
    eo_message              = DATA(message)
    es_query_info           = DATA(query_info)
    et_key                  = DATA(tor_item_keys) ).
```

### Do action

`DO_ACTION( )` is used to implement a service (operation or behavior) of a business object. An action is explicitly triggered by a service consumer, such as the user interface.

If we have certain operations which need to be performed on a business object, we would prefer to encapsulate those operations as an action on the business object as opposed to some standalone function module or class.

Every each action has own implementing class and parameter structure to perform the action. 

Also `CHECK_ACTION( )` method of `/BOBF/IF_TRA_SERVICE_MANAGER` ****interface can be used to check how it would work. It is like calling BAPI as test run.

```abap
DATA(service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

DATA(keys) = VALUE /bobf/t_frw_key( ).

DATA(service_order_parameters) = VALUE /scmtms/s_tor_a_crt_srv_order( tor_type = transportation_order_type ).

TRY.
    tor_service_manager->do_action(
      EXPORTING
        iv_act_key    = /scmtms/if_tor_c=>sc_action-root-create_service_order
        it_key        = keys
        is_parameters = REF #( service_order_parameters )
      IMPORTING
        eo_change     = DATA(change)
        eo_message    = message ).

CATCH /bobf/cx_frw_contrct_violation INTO DATA(lx_frw_contrct_violation).
  RAISE EXCEPTION lx_frw_contrct_violation.
ENDTRY.
```

### Check consistency

Consistency validations can be used to check the consistency of a business object. They can be assigned to the framework actions check of each node. Consistency validations are carried out when this action is called or automatically after a change is made if they are triggered via trigger nodes based on the changes.

```abap
DATA(keys) = VALUE /bobf/t_frw_key( ).

TRY.
    tor_service_manager->check_consistency(
      EXPORTING
        iv_node_key              = /scmtms/if_tor_c=>sc_node-root
        it_key                   = keys
        iv_check_scope           = /bobf/if_frw_c=>sc_scope_substructure
        iv_fill_inconsistent_key = abap_true
      IMPORTING
        eo_message               = DATA(message)
        et_inconsistent_key      = DATA(inconsistent_keys) ).
  CATCH /bobf/cx_frw_contrct_violation INTO DATA(lx_frw_contrct_violation).
    RAISE EXCEPTION lx_frw_contrct_violation.
ENDTRY.
```

### Check and determine

## **/BOBF/IF_TRA_TRANSACTION_MGR**

This object reference provides a transaction manager which can be used to manage transactional changes. Transactional changes could contain a single modification such as creating a node or multiple modification such as creating node, modifying a node, and calling an action.

```abap
DATA(customer_bo_configuration) = /bobf/cl_frw_factory=>get_configuration( /bobf/if_demo_customer_c=>sc_bo_key ).

DATA(text_header) = value /bobf/s_demo_longtext_hdr_k( ).
DATA(text_content) = value /bobf/s_demo_longtext_item_k( ).

DATA(modification_table) = VALUE t_frw_modification( node        = customer_bo_configuration->query_node( iv_proxy_node_name = 'ROOT_LONG_TXT.CONTENT' )
                                                     change_mode = bobf/if_frw_c=>sc_modify_create
                                                     source_node = if_demo_customer_c=>sc_node-root_long_text
                                                     source_key  = text_header->key
                                                     association = customer_bo_configuration->query_assoc( iv_node_key   = /bobf/if_demo_customer_c=>sc_node-root_long_text
                                                                                                           iv_assoc_name = 'CONTENT' ).                                                     
                                                     key         = text_content->key
                                                     data        = REF #( ****text_content ****)**** ).
```

### Save

Using of service manager inserts modification records into transaction manager like create, update, and delete. In many respects, the `SAVE()` method is similar to the `COMMIT WORK` statement in ABAP in that it commits the transactional changes to the database. Changes has done by service manager would not commit until using of `SAVE( )` method.

### Cleanup

Once a transaction is committed, we can reset the transaction manager by calling the `CLEANUP()` method. Or, alternatively, we can also use this method to abandon an in-flight transaction once an error condition has been detected. In other case, this is similar to using the `ROLLBACK WORK` statement in ABAP to rollback a transaction.

### Get transactional changes

Transaction manager tracks the changes that are made to individual business objects so that it can determine what needs to be committed and/or rolled back. 

The queued up changes can be retrieved by calling the `GET_TRANSACTIONAL_CHANGES()` method. This method will return an object reference of type `/BOBF/IF_TRA_CHANGE` that can be used to query the change list and modify it in certain cases.

## **/BOBF/IF_FRW_CONFIGURATION**

This object reference provides us with metadata for a particular business object. 
In runtime, delegated nodes don’t have a constant association keys. For this reason, `/BOBF/IF_FRW_CONFIGURATION` methods should be used when you need to get the keys.

# Transaction codes

| Transaction code | Text |
| --- | --- |
| BOBF | BOPF: Business Object Configuration |
| BOBT | Business Object Builder - Test |
| BOBX | BOPF: Business Object Configuration |

# Business objects of documents

| Business object | Description |
| --- | --- |
| /SCMTMS_TOR | Transportation Orders (Freight Unit, Freight Order, Freight Booking) |
| /SCMTMS_TRQ | Transportation Requests |

# Code snippets

## Convert alternative key

```abap
DATA(lt_keys) = VALUE /bobf/t_frw_key(  ).
DATA(lt_alt_keys) = VALUE /bofu/t_address_id( ( partner_number ) ).

TRY.
  DATA(bupa_service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /bofu/if_bupa_constants=>sc_bo_key ).
  bupa_service_manager->convert_altern_key(
    EXPORTING
      iv_node_key   = /bofu/if_bupa_constants=>sc_node-root
      iv_altkey_key = /bofu/if_bupa_constants=>sc_alternative_key-root-partner
      it_key        = lt_alt_keys
    IMPORTING
      et_key        = lt_keys ).
  CATCH /bobf/cx_frw_contrct_violation INTO DATA(frw_contrct_violation).
ENDTRY.
```

## Creating a node

```abap
DATA(root_service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
DATA(lo_trans_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

root_service_manager->retrieve_by_association(
  EXPORTING
    iv_node_key    = /scmtms/if_tor_c=>sc_node-root
    it_key         = VALUE /bobf/t_frw_key( ( key = tor_root_key ) )
    iv_association = /scmtms/if_tor_c=>sc_association-root-exec
    iv_edit_mode   = /bobf/if_conf_c=>sc_edit_exclusive
  IMPORTING
    eo_message     = DATA(message)
    et_failed_key  = DATA(failed_key) ).

IF message->check( ) EQ abap_false.
  RETURN.
ENDIF.

DATA(modification_table) = VALUE /bobf/t_frw_modification( ( change_mode = /bobf/if_frw_c=>sc_modify_create
                                                             node        = /scmtms/if_tor_c=>sc_node-executioninformation
                                                             source_node = /scmtms/if_tor_c=>sc_node-root
                                                             association = /scmtms/if_tor_c=>sc_association-root-exec
                                                             source_key  = data-parent_key
                                                             key         = data-key
                                                             data        = REF #( data ) ) ).

root_service_manager->modify(
  EXPORTING
    it_modification = modification_table
  IMPORTING
    eo_change       = DATA(change)
    eo_message      = DATA(message_srv_mgr) ).

lo_trans_mgr->save( /bobf/if_tra_c=>gc_tp_save_and_continue ).
```

## Updating a node

```abap
DATA(lt_root) = VALUE /scmtms/t_tor_root_k( ).

DATA(root_service_manager) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
DATA(transaction_manager) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

root_service_manager->retrieve(
  EXPORTING
    iv_node_key   = /scmtms/if_tor_c=>sc_node-root
    it_key        = VALUE #( ( key = key ) )
    iv_edit_mode  = /bobf/if_conf_c=>sc_edit_exclusive
    iv_fill_data  = abap_false
  IMPORTING
    et_failed_key = DATA(failed_keys)
    eo_message    = DATA(root_message) ).

IF line_exists( failed_keys[ 1 ] ).
  RETURN.
ENDIF.

DATA(modification_table) = VALUE /bobf/t_frw_modification( ( change_mode    = /bobf/if_frw_c=>sc_modify_update
                                                             node           = /scmtms/if_tor_c=>sc_node-root
                                                             key            = key
                                                             data           = REF #( data )
                                                             changed_fields = changed_fields ) ).

TRY.
  root_service_manager->modify(
    EXPORTING
      it_modification = modification_table
    IMPORTING
      eo_message      = DATA(lo_message) ).
CATCH /bobf/cx_frw_contrct_violation INTO DATA(lx_violation).
ENDTRY.

transaction_manager->save( /bobf/if_tra_c=>gc_tp_save_and_continue ).
```

## Deleting node

```abap
TRY.
    DATA(modification_table) = VALUE /bobf/t_frw_modification( ( change_mode = /bobf/if_frw_c=>sc_modify_delete
                                                                 node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                                 key         = _key ) ).

    tor_service_manager->modify(
      EXPORTING
        it_modification = modification_table
      IMPORTING
        eo_message      = message ).

CATCH /bobf/cx_frw_contrct_violation INTO DATA(frw_contrct_violation).
  RAISE EXCEPTION frw_contrct_violation.
ENDTRY.
```

## Do action

```abap
TRY.
    tor_service_manager->do_action(
      EXPORTING
        iv_act_key    = /scmtms/if_tor_c=>sc_action-root-create_service_order
        it_key        = VALUE #( ( key = freight_order_key ) )
        is_parameters = REF #( service_order_parameters )
      IMPORTING
        eo_change     = DATA(lo_change)
        eo_message    = message ).
CATCH /bobf/cx_frw_contrct_violation INTO DATA(lx_frw_contrct_violation).
  RAISE EXCEPTION lx_frw_contrct_violation.
ENDTRY.
```

## Modifying delegate node

```abap
DATA(customer_bo_configuration) = /bobf/cl_frw_factory=>get_configuration( /bobf/if_demo_customer_c=>sc_bo_key ).

DATA(text_header) = value /bobf/s_demo_longtext_hdr_k( ).
DATA(text_content) = value /bobf/s_demo_longtext_item_k( ).

DATA(modification_table) = VALUE t_frw_modification( node        = customer_bo_configuration->query_node( iv_proxy_node_name = 'ROOT_LONG_TXT.CONTENT' )
                                                     change_mode = bobf/if_frw_c=>sc_modify_create
                                                     source_node = if_demo_customer_c=>sc_node-root_long_text
                                                     source_key  = text_header->key
                                                     association = customer_bo_configuration->query_assoc( iv_node_key   = /bobf/if_demo_customer_c=>sc_node-root_long_text
                                                                                                           iv_assoc_name = 'CONTENT' ).                                                     
                                                     key         = text_content->key
                                                     data        = REF #( ****text_content ****)**** ).
```

# References

[Business Object Processing Framework | SAP Community](https://community.sap.com/topics/abap/bopf#:~:text=The%20Business%20Object%20Processing%20Framework%20is%20an%20ABAP%20OO-based,standardize%2C%20and%20modularize%20your%20development)
