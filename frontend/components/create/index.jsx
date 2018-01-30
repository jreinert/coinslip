import { Row } from 'react-bootstrap'
import React from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Form from './form'
import Modal from './modal'
import actions from 'actions'
import PropTypes from 'prop-types'

const Create = ({ slip, modal }) => (
  <Row>
    <h2>Create a new coinslip</h2>
    <Form {...slip}/>
    <Modal {...modal}/>
  </Row>
)

Create.propTypes = {
  slip: PropTypes.object.isRequired,
  modal: PropTypes.object.isRequired
}

const mapStateToProps = ({ slip, ui: { modal } }) => ({ slip, modal })

const mapDispatchToProps = dispatch => {
  const { slip: { create, update }, ui: { modal: { hide } } } = actions
  return {
    slip: bindActionCreators({ onSubmit: create, onChange: update }, dispatch),
    modal: bindActionCreators({ onHide: hide }, dispatch)
  }
}

const mergeProps = (
  { slip: slipState, modal: modalState },
  { slip: slipDispatch, modal: modalDispatch }
) => {
  const { redeemURL, amount, currency } = slipState
  return {
    slip: { ...slipState, ...slipDispatch },
    modal: { ...modalState, ...modalDispatch, redeemURL, amount, currency }
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Create)
