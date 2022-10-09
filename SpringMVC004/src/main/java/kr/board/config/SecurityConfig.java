package kr.board.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.web.filter.CharacterEncodingFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		//요청에 대한 설정
		
		//로그인 할 때 한글인코딩에 관한 설정을 하는거다.
		//시큐리티가 적용된 다음 post 방식으로 넘어온 한글 인코딩같은 경우 
		//스프링 환경설정 파일의 configure 메소드에 필터를 등록해야한다.
		CharacterEncodingFilter filter = new CharacterEncodingFilter();
		filter.setEncoding("UTF-8");
		filter.setForceEncoding(true);
		http.addFilterBefore(filter,CsrfFilter.class);
	}
	
	
	//패스워드를 인코딩 해줄 객체가 필요한데 스프링 시큐리팅에서 제공해주는 클래스를 사용하자
	//@Bean을 해주는 이유는 SecurityConfig.java 파일이 실행이 될 때 이 메소드가 실행되어
	//객체를 만들어 @Autowired를 해줘야하기 때문이다.
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
}
