using Microsoft.AspNetCore.Mvc;
using OrderService.Contracts.Controllers;
using OrderService.Contracts.Models;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;

namespace OrderService.Api.Controllers
{
    /// <inheritdoc/>
    [ApiVersion("2021-06-23")]
    public class OrderController : OrdersApiController
    {
        /// <inheritdoc/>
        public override Task<IActionResult> GetOrderById([FromRoute(Name = "orderId"), Required] Guid orderId)
        {
            throw new NotImplementedException();
        }

        /// <inheritdoc/>
        public override async Task<IActionResult> GetOrders()
        {
            throw new NotImplementedException();
        }

        /// <inheritdoc/>
        public override Task<IActionResult> PostOrder([FromBody] Order order)
        {
            throw new NotImplementedException();
        }

        /// <inheritdoc/>
        public override Task<IActionResult> UpdateOrderById([FromRoute (Name = "orderId")][Required] Guid orderId, [FromBody] Order order)
        {
            throw new NotImplementedException();
        }
    }
}
