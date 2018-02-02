package com.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.client.CoinMapper;
import com.client.CoinPerUserMapper;
import com.client.ExchangeMapper;
import com.client.QuotationMapper;
import com.jsonmodel.PriceChart;
import com.main.CalcSatoshisHist;
import com.model.Coin;
import com.model.CoinPerUser;
import com.model.Exchange;
import com.model.Quotation;

@Controller("/")
public class MainController extends PrincipalController {

	@Autowired
	private CoinPerUserMapper coinPerUserservice;
	@Autowired
	private QuotationMapper quotationMapper;
	@Autowired
	private ExchangeMapper exchangeMapper;
	@Autowired
	private CoinMapper coinMapper;

	@GetMapping("/")
	public String welcome(Map<String, Object> model) {
		for (CoinPerUser coinUser : coinPerUserservice.selectByUserLogin(getUserName())) {
			quotationMapper.selectByBuyDate(coinUser.getCoinByExchange().getCoin(),
					coinUser.getCoinByExchange().getExchange(), coinUser.getBuyDate());
		}
		model.put("crypto", coinPerUserservice.selectByUserLogin(getUserName()));

		return "index";
	}

	@RequestMapping(value = "/configPerUser", method = RequestMethod.GET)
	public String configPerUser(Map<String, Object> model) {
		model.put("registroEditado", new CoinPerUser());

		return "coinPerUserConfig";
	}

	@RequestMapping(value = "/exchangeList", method = RequestMethod.GET)
	@ResponseBody
	public List<Exchange> exchangeList(Map<String, Object> model) {
		return exchangeMapper.selectAll();
	}

	@RequestMapping(value = "/coinList", method = RequestMethod.GET)
	@ResponseBody
	public List<Coin> coinList(Map<String, Object> model,
			@RequestParam(value = "term[term]", required = false) String name) {

		if (!StringUtils.isEmpty(name)) {
			return coinMapper.searchByName(name);
		}
		return coinMapper.selectAll();
	}

	@RequestMapping(value = "/getHistoricData", method = RequestMethod.GET)
	@ResponseBody
	public List<PriceChart> welcome(@RequestParam("idCrypto") Integer idCrypto,
			@RequestParam("idExchange") Integer idExchange) {

		List<PriceChart> result = new ArrayList<>();
		for (CoinPerUser coinUser : coinPerUserservice.selectByUserCryptoExcange(getUserName(), idCrypto, idExchange)) {
			List<Quotation> quota = quotationMapper.selectByBuyDate(coinUser.getCoinByExchange().getCoin(),
					coinUser.getCoinByExchange().getExchange(), coinUser.getBuyDate());

			Coin coin = new Coin();
			coin.setId(coinMapper.selectByShortName("BTC").getId());
			Exchange exchange = new Exchange();
			exchange.setId(1);
			List<Quotation> btcList = quotationMapper.selectAllByCoinExchange(coin, exchange);
			for (Quotation quotation : quota) {
				Quotation btcPrice = null;
				for (Quotation btc : btcList) {
					if (btcPrice == null && (quotation.getTimestamp().equals(btc.getTimestamp())
							|| (btcList.indexOf(btc)+1 < btcList.size() && quotation.getTimestamp().before(btc.getTimestamp()))
							&& quotation.getTimestamp().after(btcList.get(btcList.indexOf(btc)+1).getTimestamp()))) {
						btcPrice = btc;
					}
				}
				if (btcPrice != null) {
					result.add(new CalcSatoshisHist().calc(coinUser, quotation, btcPrice.getSatoshis().doubleValue()));
				}
			}

		}

		return result;
	}

}
