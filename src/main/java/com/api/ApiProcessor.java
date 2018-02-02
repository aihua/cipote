package com.api;

import java.math.BigDecimal;
import java.text.MessageFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import com.client.CoinByExchangeMapper;
import com.client.CoinMapper;
import com.client.CoinPerUserMapper;
import com.client.ExchangeMapper;
import com.client.QuotationMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.main.CalcSatoshis;
import com.main.UserOnline;
import com.model.CoinByExchange;
import com.model.Exchange;
import com.model.Quotation;

import ch.qos.logback.classic.Logger;

@Configuration
public class ApiProcessor {
	@Autowired
	private CoinByExchangeMapper coinByExchangeMapper;
	@Autowired
	private QuotationMapper quotationMapper;
	@Autowired
	private CoinPerUserMapper service;
	@Autowired
	private SimpMessagingTemplate webSocket;
	@Autowired
	private CoinMapper coinMapper;
	@Autowired
	private ExchangeMapper exchangeMapper;

	private static ExchangeMapper exchangeMapperStatic;

	@PostConstruct
	private void init() {
		exchangeMapperStatic = exchangeMapper;
	}

	private static final Logger LOG = (Logger) LoggerFactory.getLogger(ApiProcessor.class);

	public static String getUrlApiByExchangeName(String exchangeName, String nameCoin, String nameCoinPair) {
		if (LOG.isDebugEnabled()) {
			LOG.debug("Calling " + exchangeName);
		}

		Exchange exchange = getExchangeByName(exchangeName);

		return MessageFormat.format(exchange.getExchangeApi().getApiUrl(), nameCoin, nameCoinPair);
	}

	public static Exchange getExchangeByName(String exchangeName) {
		return exchangeMapperStatic.selectByName(exchangeName);
	}

	public List<CoinByExchange> getListByIdExchange(Integer exchangeId) {
		return coinByExchangeMapper.selectByExchange(exchangeId);
	}

	public void insertQuotaAndSend(CoinByExchange crypto, BigDecimal price) {
		Quotation record = new Quotation();
		CoinByExchange reg = new CoinByExchange();
		reg.setCoin(crypto.getCoin());
		reg.setExchange(crypto.getExchange());
		record.setCoinByExchange(reg);
		record.setSatoshis(price);
		record.setTimestamp(new Date());
		quotationMapper.insertSelective(record);
		try {
			sendSocketMessage(record, crypto);
		} catch (JsonProcessingException e) {
			LOG.error("Exception", e);
		}

	}

	private void sendSocketMessage(Quotation record, CoinByExchange crypto) throws JsonProcessingException {
		new CalcSatoshis().last(UserOnline.listUserOnline(), record, crypto, service, quotationMapper, webSocket, coinMapper);
	}
}
