import React from 'react'
import PropTypes from 'prop-types'

const SlipInfo = ({ amount, currency }) => (
  <table className="table">
    <tbody>
      <tr>
        <th>Amount</th>
        <td>{amount}</td>
      </tr>
      <tr>
        <th>Currency</th>
        <td>{currency}</td>
      </tr>
    </tbody>
  </table>
)

SlipInfo.propTypes = {
  amount: PropTypes.number.isRequired,
  currency: PropTypes.string.isRequired
}

export default SlipInfo
