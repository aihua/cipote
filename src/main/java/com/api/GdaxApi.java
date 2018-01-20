package com.api;

import java.math.BigDecimal;
import java.util.Date;

import javax.websocket.ClientEndpoint;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.client.RestTemplate;

import com.client.QuotationMapper;
import com.jsonmodel.PriceBittrex;
import com.model.Coin;
import com.model.CoinByExchange;
import com.model.Exchange;
import com.model.Quotation;

@Configuration
@ClientEndpoint
@EnableScheduling
public class GdaxApi {

	@Autowired 
	private QuotationMapper quotationMapper;
	
	static final String BASE_API = "https://api.gdax.com";
	private String lastPrice = "0";

	@Scheduled(cron = "*/10 * * * * *")
	public void startBittrex() {

				RestTemplate restTemplate = new RestTemplate();
				PriceBittrex result = restTemplate
						.getForObject(BASE_API + "/products/BTC-EUR/ticker", PriceBittrex.class);

				String last = result.getAdditionalProperties().get("price").toString();
					lastPrice = last;
					Quotation record = new Quotation();
					CoinByExchange reg = new CoinByExchange();
					Coin coin = new Coin();
					coin.setId(1);
					reg.setCoin(coin);
					Exchange exchange = new Exchange();
					exchange.setId(1);
					reg.setExchange(exchange);
					record.setCoinByExchange(reg);
					record.setSatoshis(new BigDecimal(lastPrice));
					record.setTimestamp(new Date());
					quotationMapper.insertSelective(record);
//				}
			}

}
