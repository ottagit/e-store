atom_feed do |feed|
  feed.title "Who bought #{@product.title}"

  feed.updated @latest_order.try(:updated_at)

  @product.orders.each do |order|
    feed.entry(order) do |entry|
      entry.title "Order: #{order.id}"
      entry.summary type: 'xhtml' do |xhtml|
        xhtml.p "Shipped to #{order.address}"

        xhtml.table do 
          xhtml.tr do
            xhtml.th 'Product'
            xhtml.th 'Quantity'
            xhtml.th 'Total price'
          end
          order.line_items.each do |li|
            xhtml.tr do
              xhtml.td li.product.title
              xhtml.td li.quantity
              xhtml.td number_to_currency li.total_price
            end
          end
          xhtml.tr do
            xhtml.th 'Total', colsapn: 2
            xhtml.th number_to_currency(order.line_items.map(&:total_price).sum)
          end
        end

        xhtml.p "Payed by #{order.pay_type}"
      end

      entry.author do |author|
        author.name order.name
        author.email order.email
      end
    end
  end
end

