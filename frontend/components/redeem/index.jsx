import { Row } from 'react-bootstrap'
import React from 'react'
import PropTypes from 'prop-types'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import actions from 'actions'
import SlipInfo from '../slip-info'
import Form from './form'

const Redeem = ({ onChange, onSubmit, request }) => {
  return (
    <Row>
      <h2>Redeem a Coinslip</h2>
      <SlipInfo { ...request } />
      <Form request={request} onChange={onChange} onSubmit={onSubmit} />
    </Row>
  )
}

Redeem.propTypes = {
  onChange: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  request: PropTypes.object.isRequired
}

const mapStateToProps = ({ redeemRequest: request }) => ({ request })

const { redeemRequest: { requestPayment, update } } = actions
const mapDispatchToProps = dispatch => bindActionCreators({
  onSubmit: requestPayment,
  onChange: update
}, dispatch)

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Redeem)
