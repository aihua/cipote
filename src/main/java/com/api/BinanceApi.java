package com.api;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.websocket.ClientEndpoint;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.client.RestTemplate;

import com.client.CoinByExchangeMapper;
import com.client.CoinPerUserMapper;
import com.client.QuotationMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.jsonmodel.PriceBittrex;
import com.jsonmodel.PriceChart;
import com.main.CalcSatoshis;
import com.main.UserOnline;
import com.model.CoinByExchange;
import com.model.Quotation;

@Configuration
@ClientEndpoint
@EnableScheduling
public class BinanceApi {

	@Autowired
	private CoinByExchangeMapper coinByExchangeMapper;
	@Autowired 
	private QuotationMapper quotationMapper;
	@Autowired
	private CoinPerUserMapper service;
	@Autowired
	private SimpMessagingTemplate webSocket;
	
	static final String BASE_API = "https://api.binance.com/api/v1";
	private String lastPrice = "0";

	@Scheduled(cron = "*/10 * * * * *")
	public void startBittrex() {

		List<CoinByExchange> list = coinByExchangeMapper.getAll();

		for (CoinByExchange crypto : list) {

			if (crypto.getExchange().getName().equals("BINANCE")) {
				RestTemplate restTemplate = new RestTemplate();
				PriceBittrex result = restTemplate
						.getForObject(BASE_API + "/ticker/price?symbol="+crypto.getCoin().getShortName()+"BTC", PriceBittrex.class);

				String last = result.getAdditionalProperties().get("price").toString();
					lastPrice = last;
					Quotation record = new Quotation();
					CoinByExchange reg = new CoinByExchange();
					reg.setCoin(crypto.getCoin());
					reg.setExchange(crypto.getExchange());
					record.setCoinByExchange(reg);
					record.setSatoshis(new BigDecimal(lastPrice));
					record.setTimestamp(new Date());
					quotationMapper.insertSelective(record);
					PriceChart price = new PriceChart();
					price.setPrice(Double.valueOf(lastPrice));
					price.setTime(new Date().getTime());
					try {
						new CalcSatoshis().last(UserOnline.listUserOnline(), record, crypto.getExchange().getId(), crypto.getCoin().getId(), service, quotationMapper, webSocket);
					} catch (JsonProcessingException e) {
						// TODO Auto-generated catch block
					}
//				}
			}
		}
	}

}
